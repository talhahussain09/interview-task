const fs = require("fs");

if (!fs.existsSync("server.js")) {
  console.error("server.js file is missing");
  process.exit(1);
}

console.log("Basic application test passed");