let moduleBytes = fetch("module.wasm").then((response) => response.arrayBuffer())

// Listen for messages from the main thread.
onmessage = function(e) {
    let memory = e.data;
    let imports = {env: {memory: memory}};
    let module = WebAssembly.instantiate(moduleBytes, imports).then(
        ({instance}) => {
            instance.exports.start();
        });
};

onmessage = function(e) {
    console.log(e)
};