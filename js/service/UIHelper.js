
var BackgroundImagesList = [
        "qrc:/res/images/login-bg/attack-on-titan-file.png",
        "qrc:/res/images/login-bg/naruto-shippuden.png",
        "qrc:/res/images/login-bg/one-punch-clipart.png",
        "qrc:/res/images/login-bg/sword-art-transparent.png",
       // "qrc:/res/images/goku_dragon_ball_super_2-wallpaper-1440x2560.jpg",
        ];

function getRandomBackgroundImagePath() {
     var randomInt = Math.floor(Math.random() * BackgroundImagesList.length);
     console.log("randomInt: "+ randomInt)
     return BackgroundImagesList[randomInt];
}
