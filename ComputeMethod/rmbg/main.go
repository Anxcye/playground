package main

import (
	"fmt"
	"math"
)

// Function 是被积函数的类型
type Function func(float64) float64

// Romberg 使用龙贝格积分法计算函数 f 在区间 [a, b] 上的积分
// n 是迭代次数
func Romberg(f Function, a, b float64, n int) float64 {
	h := (b - a) / float64(n)
	R := make([][]float64, int(math.Log2(float64(n))+1))
	for i := range R {
		R[i] = make([]float64, i+1)
	}

	R[0][0] = h / 2 * (f(a) + f(b))

	for i := 1; i < len(R); i++ {
		h /= 2
		sum := 0.0
		for k := 1; k <= n; k += 2 {
			sum += f(a + float64(k)*h)
		}
		R[i][0] = 0.5*R[i-1][0] + sum*h

		for j := 1; j <= i; j++ {
			R[i][j] = R[i][j-1] + (R[i][j-1]-R[i-1][j-1])/(math.Pow(4, float64(j))-1)
		}
		n *= 2
	}

	return R[len(R)-1][len(R)-1]
}

func main() {
	// 这是一个示例函数
	f := func(x float64) float64 {
		return 3*math.Pow(x, 2) + 2*x + 1
	}

	result := Romberg(f, 0, 1, 8) 
	fmt.Println("The integral is:", result)
}