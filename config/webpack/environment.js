const { environment } = require('@rails/webpacker')
const webpack = require('webpack')
environment.plugins.prepend(
    'Provide',
    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        jquery: 'jquery',
        'window.jQuery': 'jquery'
    })
)

module.exports = environment


// const { environment } = require('@rails/webpacker')
// const webpack = require('webpack')
// const vue =  require('./loaders/vue')
//
// environment.plugins.prepend(
//     'Provide',
//     new webpack.ProvidePlugin({
//         $: 'jquery',
//         jQuery: 'jquery',
//         jquery: 'jquery',
//         'window.jQuery': 'jquery'
//     })
// )
//
// // resolve-url-loader must be used before sass-loader
// environment.loaders.get('sass').use.splice(-1, 0, {
//     loader: 'resolve-url-loader'
// });
//
// environment.loaders.append('vue', vue)
// module.exports = environment
