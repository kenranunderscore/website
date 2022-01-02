if (module.hot) {
    module.hot.accept(function () {
        console.log('reloading...');
    });

    module.hot.dispose(function () {
        console.log('disposing...');
        // FIXME(Johannes): this looks like it's not the way to go,
        // but it's hard to find good information on this.
        document.body.innerHTML = '';
    });
}

console.log('Initial startup');

require('./output/Main').main();
