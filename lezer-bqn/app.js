import { parser } from "lezer-bqn";

process.stdin.on("data", data => {
    let input = data.toString();
let tree = parser.parse(input);
let cursor = tree.cursor();

    let output = "";

cursor.iterate(node => {
  output += `${node.name} ${input.slice(cursor.from, cursor.to)} from ${cursor.from} to ${cursor.to} \n`
});

    process.stdout.write(output)
})


