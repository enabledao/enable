const ngrok = require("ngrok");
const { exec } = require("child_process");

console.log("starting ngrok");

(async function() {
  const url = await ngrok.connect({
    addr: 8080,
    host_header: "rewrite"
  });

  console.log(`ngrok url: ${url}`);

  exec(
    `SERVER_URL=${url} sh ./bin/start-dev-client`,
    (error, stdout, stderr) => {
      console.log(`Error: ${error}`);
      console.log(`Stdout: ${stdout}`);
      console.log(`Stderr: ${stderr}`);
    }
  );
})();
