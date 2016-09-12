package utils

import (
	//"fmt"
	//"graphics"
	"image"
	"image/jpeg"
	"log"
	//"net/http"
	"os"
	//"strconv"
	"strings"

	//"code.google.com/p/graphics-go/graphics"
	"github.com/BurntSushi/graphics-go/graphics"
)

//http://studygolang.com/articles/3375
//http://studygolang.com/articles/4307
//http://studygolang.com/articles/2581
//http://studygolang.com/articles/2453
func DoImageHandler(url string, newdx int) {
	src, err := LoadImage("." + url)
	//bound := src.Bounds()
	//dx := bound.Dx()
	//dy := bound.Dy()
	if err != nil {
		log.Fatal(err)
	}
	//fmt.Println(dx, dy, newdx)
	// 缩略图的大小
	dst := image.NewRGBA(image.Rect(640, 640, 200, 200))
	//dst := image.NewRGBA(image.Rect(0, 0, newdx, newdx*dy/dx))
	// 产生缩略图,等比例缩放
	//err = graphics.Scale(dst, src)
	err = graphics.Thumbnail(dst, src)
	if err != nil {
		log.Fatal(err)
	}

	filen := strings.Replace(url, ".", "-cropper.", -1)
	file, err := os.Create("." + filen)
	defer file.Close()

	err = jpeg.Encode(file, dst, &jpeg.Options{100}) //图像质量值为100，是最好的图像显示

	//header := w.Header()
	//header.Add("Content-Type", "image/jpeg")

	//png.Encode(w, dst)
}

// Load Image decodes an image from a file of image.
func LoadImage(path string) (img image.Image, err error) {
	file, err := os.Open(path)
	if err != nil {
		return
	}
	defer file.Close()
	img, _, err = image.Decode(file)
	return
}

/*file, err := os.Open("./" + filepath)
if err != nil {
	fmt.Println(err)
}
defer file.Close()

file1, err := os.Create(dir + "/" + "test1.jpg")
if err != nil {
	fmt.Println(err)
}
defer file1.Close()

m, _, _ := image.Decode(file) // 图片文件解码
rgbImg := m.(*image.YCbCr)
subImg := rgbImg.SubImage(image.Rect(0, 0, 200, 200)).(*image.YCbCr) //图片裁剪x0 y0 x1 y1
err = jpeg.Encode(file1, subImg, &jpeg.Options{100})                 //图像质量值为100，是最好的图像显示
if err != nil {
	fmt.Println(err)
}
*/
