const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");

const CELL_SIZE = 30;
const GRID_SIZE = 20;

let snake = [{ x: 10, y: 10 }];
let apple = { x: 5, y: 5 };
let dx = 0;
let dy = 0;
let score = 0;

// Load images
const snakeHeadImg = new Image();
snakeHeadImg.src = 'snake.png';

const snakeBodyImg = new Image();
snakeBodyImg.src = 'snake_body.png';

const snakeTailImg = new Image();
snakeTailImg.src = 'snake_tail.png';

const appleImg = new Image();
appleImg.src = 'apple.png';

// Utility: draw an image rotated at (x, y) cell
function drawRotatedImage(img, x, y, angleRad) {
  ctx.save();
  ctx.translate(x * CELL_SIZE + CELL_SIZE / 2, y * CELL_SIZE + CELL_SIZE / 2);
  ctx.rotate(angleRad);
  ctx.drawImage(img, -CELL_SIZE / 2, -CELL_SIZE / 2, CELL_SIZE, CELL_SIZE);
  ctx.restore();
}

function getDirection(from, to) {
  if (!from || !to) return null;
  if (from.x === to.x && from.y === to.y - 1) return 0; // Up
  if (from.x === to.x && from.y === to.y + 1) return Math.PI; // Down
  if (from.x === to.x - 1 && from.y === to.y) return Math.PI / 2; // Right
  if (from.x === to.x + 1 && from.y === to.y) return -Math.PI / 2; // Left
  return 0; // fallback
}

// For body turns
function getBodyAngle(prev, curr, next) {
  // Straight
  if (prev.x === next.x) return 0; // vertical, face up by default
  if (prev.y === next.y) return Math.PI / 2; // horizontal

  // Corners
  if (
    (prev.x < curr.x && next.y < curr.y) ||
    (next.x < curr.x && prev.y < curr.y)
  )
    return -Math.PI / 2; // left-up corner

  if (
    (prev.x < curr.x && next.y > curr.y) ||
    (next.x < curr.x && prev.y > curr.y)
  )
    return Math.PI; // left-down

  if (
    (prev.x > curr.x && next.y < curr.y) ||
    (next.x > curr.x && prev.y < curr.y)
  )
    return 0; // right-up (default)

  if (
    (prev.x > curr.x && next.y > curr.y) ||
    (next.x > curr.x && prev.y > curr.y)
  )
    return Math.PI / 2; // right-down

  return 0;
}

function drawCell(x, y, color, type, part = "body", angleRad = 0) {
  if (type === 'snake') {
    if (part === "head" && snakeHeadImg.complete) {
      drawRotatedImage(snakeHeadImg, x, y, angleRad);
    } else if (part === "tail" && snakeTailImg.complete) {
      drawRotatedImage(snakeTailImg, x, y, angleRad);
    } else if (snakeBodyImg.complete) {
      drawRotatedImage(snakeBodyImg, x, y, angleRad);
    } else {
      ctx.fillStyle = color;
      ctx.fillRect(x * CELL_SIZE, y * CELL_SIZE, CELL_SIZE, CELL_SIZE);
    }
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

  // Set game background
  ctx.fillStyle = "#44BD3A";
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  drawGrid();
  drawCell(apple.x, apple.y, "red", "apple");

  // Draw snake with correct directions
  for (let i = 0; i < snake.length; i++) {
    let angle = 0;
    let part = "body";
    if (i === 0) {
      // Head: direction is from neck to head
      if (snake.length > 1) angle = getDirection(snake[1], snake[0]);
      part = "head";
    } else if (i === snake.length - 1) {
      // Tail: direction is from previous segment to tail
      if (snake.length > 1) angle = getDirection(snake[snake.length - 2], snake[i]);
      part = "tail";
    } else {
      // Body: direction is based on neighbors
      angle = getBodyAngle(snake[i - 1], snake[i], snake[i + 1]);
      part = "body";
    }
    drawCell(snake[i].x, snake[i].y, "#15603c", "snake", part, angle);
  }
}

// Slow down the game!
let loop = setInterval(gameLoop, 200);

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
