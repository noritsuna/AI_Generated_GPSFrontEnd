// ELK layered layout with orthogonal edge routing: node elk_layout.js in.json out.json
const fs = require("fs");
const ELK = require("elkjs/lib/elk.bundled.js");
const g = JSON.parse(fs.readFileSync(process.argv[2], "utf8"));
new ELK().layout(g).then(r => fs.writeFileSync(process.argv[3], JSON.stringify(r)))
  .catch(e => { console.error(e); process.exit(1); });
