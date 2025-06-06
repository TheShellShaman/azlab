const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");
let snake = [{ x: 10, y: 10 }];
let apple = { x: 5, y: 5 };
let dx = 0;
let dy = 0;
let score = 0;

function drawCell(x, y, color) {
  ctx.fillStyle = color;
  ctx.fillRect(x * 20, y * 20, 20, 20);
}

function gameLoop() {
  let head = { x: snake[0].x + dx, y: snake[0].y + dy };
  snake.unshift(head);

  if (head.x === apple.x && head.y === apple.y) {
    score++;
    apple = { x: Math.floor(Math.random() * 20), y: Math.floor(Math.random() * 20) };
  } else {
    snake.pop();
  }

  if (head.x < 0 || head.y < 0 || head.x >= 20 || head.y >= 20 || snake.slice(1).some(s => s.x === head.x && s.y === head.y)) {
    clearInterval(loop);
    alert("Game over! Score: " + score);
  }

  ctx.clearRect(0, 0, canvas.width, canvas.height);
  drawCell(apple.x, apple.y, "red");
  snake.forEach(s => drawCell(s.x, s.y, "green"));
}

let loop = setInterval(gameLoop, 150);

document.addEventListener("keydown", e => {
  if (e.key === "ArrowUp") [dx, dy] = [0, -1];
  if (e.key === "ArrowDown") [dx, dy] = [0, 1];
  if (e.key === "ArrowLeft") [dx, dy] = [-1, 0];
  if (e.key === "ArrowRight") [dx, dy] = [1, 0];
});

document.getElementById("submitScore").addEventListener("click", async () => {
  const name = document.getElementById("playerName").value;
  await fetch("https://YOUR-FUNCTION-APP.azurewebsites.net/api/highscore", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, score })
  });
});

fetch("https://YOUR-FUNCTION-APP.azurewebsites.net/api/highscore")
  .then(res => res.json())
  .then(data => {
    const leaderboard = document.getElementById("leaderboard");
    data.slice(0, 10).forEach(entry => {
      const li = document.createElement("li");
      li.textContent = `${entry.name || "Anonymous"}: ${entry.score}`;
      leaderboard.appendChild(li);
    });
  });