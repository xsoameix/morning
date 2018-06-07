var HtmlWebpackPlugin = require('html-webpack-plugin');
var path = require('path');

module.exports = {
    entry: './index.ls',
    output: {
        path: path.join(__dirname, 'build'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
        {
            test: /\.ls$/,
            loader: 'livescript-loader'
        },
        {
            test: /\.jade$/,
            loader: ['html-loader', 'pug-html-loader']
        }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            filename: 'index.html',
            template: 'index.jade',
            inject: 'body'
        })
    ]
};
