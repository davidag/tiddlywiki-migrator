const fs = require('fs');

if (process.argv.length != 4) {
    console.log("Wrong parameters");
    process.exit(1);
}

const TIDDLYWIKI_INFO_FILE = process.argv[2];
const PLUGIN_NAME = process.argv[3];

let data = fs.readFileSync(TIDDLYWIKI_INFO_FILE);

let info = JSON.parse(data);
info.plugins.push(PLUGIN_NAME);

fs.writeFileSync(TIDDLYWIKI_INFO_FILE, JSON.stringify(info, null, 4));
