import logging
import azure.functions as func
from azure.data.tables import TableServiceClient
from azure.identity import DefaultAzureCredential
import os
import json
from uuid import uuid4

# Initialize the function app
def main(req: func.HttpRequest) -> func.HttpResponse:
    account_url = f"https://{os.environ['jacobsazlabstorage2']}.table.core.windows.net"
    table_service = TableServiceClient(endpoint=account_url, credential=DefaultAzureCredential())
    table_client = table_service.get_table_client(os.environ["highscores"])

    if req.method == "POST":
        try:
            data = req.get_json()
            name = data.get("name", "Anonymous")
            score = int(data.get("score", 0))

            entity = {
                "PartitionKey": "highscore",
                "RowKey": f"{name}-{score}-{uuid4()}",
                "name": name,
                "score": score
            }
            table_client.create_entity(entity=entity)
            return func.HttpResponse("Score submitted", status_code=200)
        except Exception as e:
            logging.error(f"Error: {e}")
            return func.HttpResponse("Error submitting score", status_code=500)

    elif req.method == "GET":
        try:
            entities = table_client.query_entities("PartitionKey eq 'highscore'")
            top_scores = sorted(entities, key=lambda x: x['score'], reverse=True)[:10]
            result = [{"name": e["name"], "score": e["score"]} for e in top_scores]
            return func.HttpResponse(json.dumps(result), mimetype="application/json", status_code=200)
        except Exception as e:
            logging.error(f"Error: {e}")
            return func.HttpResponse("Error retrieving scores", status_code=500)
    else:
        return func.HttpResponse("Method not allowed", status_code=405)


