const http = require("http");

const PORT = process.env.PORT || 3000;

const server = http.createServer((req, res) => {
  if (req.url === "/health") {
    res.writeHead(200, { "Content-Type": "application/json" });
    res.end(JSON.stringify({ status: "ok" }));
    return;
  }

  res.writeHead(200, { "Content-Type": "text/html" });
  res.end(`
    <!DOCTYPE html>
    <html>
      <head>
        <title>DevOps Interview Task</title>
      </head>
      <body>
        <h1>DevOps Interview Task</h1>
        <p>Application deployed using Docker, GitHub Actions, Terraform, and AWS EC2.</p>
        <p>Status: Running successfully</p>
      </body>
    </html>
  `);
});

server.listen(PORT, () => {
  console.log(`Application is running on port ${PORT}`);
});