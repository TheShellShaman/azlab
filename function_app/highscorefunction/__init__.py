#import necessary libraries
#comment to rerun the function
import logging
import os
import azure.functions as func
from azure.data.tables import TableServiceClient
from azure.identity import DefaultAzureCredential

def main(req: func.HttpRequest) -> func.HttpResponse:
    logging.info('Python HTTP trigger function processed a request.')

    # You need your storage account name, NOT the connection string
    storage_account_name = os.getenv('STORAGE_ACCOUNT_NAME')  # Set in App Settings
    if not storage_account_name:
        return func.HttpResponse("Missing STORAGE_ACCOUNT_NAME env var.", status_code=500)

    try:
        credential = DefaultAzureCredential()
        table_service = TableServiceClient(
            endpoint=f"https://{storage_account_name}.table.core.windows.net",
            credential=credential
        )
        table_client = table_service.get_table_client(table_name="highscores")  # change if needed

        # Try to list entities (just to test permissions)
        entities = list(table_client.list_entities())
        logging.info(f"Found {len(entities)} entities in HighScores table.")

        return func.HttpResponse("success", status_code=200)
    except Exception as e:
        logging.error(f"Error: {e}")
        return func.HttpResponse(f"Failed: {str(e)}", status_code=500)