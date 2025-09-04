// Section 2: JavaScript closures & scope
function funcsVar() {
  const fs = [];
  for (var i = 0; i < 3; i++) fs.push(x => x + i);
  return fs;
}
function funcsLet() {
  const fs = [];
  for (let i = 0; i < 3; i++) fs.push(x => x + i);
  return fs;
}

console.log("JS var (late-bound):", funcsVar().map(f => f(10)));
console.log("JS let (per-iter): ", funcsLet().map(f => f(10)));
