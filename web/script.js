const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");

const CELL_SIZE = 30;      // Each cell is 30x30 pixels
const GRID_SIZE = 20;      // 20x20 grid for a 600x600 canvas

let snake = [{ x: 10, y: 10 }];
let apple = { x: 5, y: 5 };
let dx = 0;
let dy = 0;
let score = 0;

// Load your images
const snakeImg = new Image();
snakeImg.src = 'snake.png'; // Your custom snake head/body image

const appleImg = new Image();
appleImg.src = 'apple.png'; // Your custom apple image

// Draw a cell (with images)
function drawCell(x, y, color, type) {
  if (type === 'snake' && snakeImg.complete) {
    ctx.drawImage(snakeImg, x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
  } else if (type === 'apple' && appleImg.complete) {
    ctx.drawImage(appleImg, x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
  } else {
    ctx.fillStyle = color;
    ctx.fillRect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
  }
}

// Draw grid
function drawGrid() {
  ctx.strokeStyle = "#cce8cc";
  ctx.lineWidth = 1;
  for (let i = 0; i <= GRID_SIZE; i++) {
    ctx.beginPath();
    ctx.moveTo(i * CELL_SIZE, 0);
    ctx.lineTo(i * CELL_SIZE, GRID_SIZE * CELL_SIZE);
    ctx.stroke();

    ctx.beginPath();
    ctx.moveTo(0, i * CELL_SIZE);
    ctx.lineTo(GRID_SIZE * CELL_SIZE, i * CELL_SIZE);
    ctx.stroke();
  }
}

function gameLoop() {
  let head = { x: snake[0].x + dx, y: snake[0].y + dy };
  snake.unshift(head);

  // Eat apple
  if (head.x === apple.x && head.y === apple.y) {
    score++;
    // Ensure new apple is not on the snake
    let collision;
    do {
      apple = {
        x: Math.floor(Math.random() * GRID_SIZE),
        y: Math.floor(Math.random() * GRID_SIZE)
      };
      collision = snake.some(s => s.x === apple.x && s.y === apple.y);
    } while (collision);
  } else {
    snake.pop();
  }

  // Check for game over
  if (
    head.x < 0 || head.y < 0 ||
    head.x >= GRID_SIZE || head.y >= GRID_SIZE ||
    snake.slice(1).some(s => s.x === head.x && s.y === head.y)
  ) {
    clearInterval(loop);
    alert("Game over! Score: " + score);
    return;
  }

  // Draw everything
  ctx.clearRect(0, 0, canvas.width, canvas.height);

  // Light green background (in case CSS not applied)
  ctx.fillStyle = "#d6f5d6";
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  drawGrid();
  drawCell(apple.x, apple.y, "red", "apple");
  snake.forEach(s => drawCell(s.x, s.y, "#15603c", "snake"));
}

let loop = setInterval(gameLoop, 120);

// Direction controls
document.addEventListener("keydown", e => {
  if (e.key === "ArrowUp" && dy !== 1) [dx, dy] = [0, -1];
  if (e.key === "ArrowDown" && dy !== -1) [dx, dy] = [0, 1];
  if (e.key === "ArrowLeft" && dx !== 1) [dx, dy] = [-1, 0];
  if (e.key === "ArrowRight" && dx !== -1) [dx, dy] = [1, 0];
});

// Submit score to your Azure Function
document.getElementById("submitScore").addEventListener("click", async () => {
  const name = document.getElementById("playerName").value;
  await fetch("https://YOUR-FUNCTION-APP.azurewebsites.net/api/highscore", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ name, score })
  });
});

// Fetch and display leaderboard
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
