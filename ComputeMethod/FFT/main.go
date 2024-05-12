package main

import (
	"fmt"
	"math"
	"math/cmplx"
)

func FFT(x []complex128) []complex128 {
	N := len(x)
	if N == 1 {
		return x
	}

	// 分离出偶数和奇数部分
	even := make([]complex128, N/2)
	odd := make([]complex128, N/2)
	for i := 0; i < N/2; i++ {
		even[i] = x[i*2]
		odd[i] = x[i*2+1]
	}

	// 递归调用FFT
	fftEven, fftOdd := FFT(even), FFT(odd)

	// 合并结果
	result := make([]complex128, N)
	for i := 0; i < N/2; i++ {
		t := cmplx.Rect(1, -2*math.Pi*float64(i)/float64(N)) * fftOdd[i]
		result[i] = fftEven[i] + t
		result[i+N/2] = fftEven[i] - t
	}

	return result
}

func f(x float64) complex128 {
	return complex(x*x*math.Cos(x), 0)
}

func main() {
	// 生成f(x)的样本点
	samples := make([]complex128, 16)
	for i := range samples {
		x := -math.Pi + 2*math.Pi*float64(i)/16
		samples[i] = f(x)
	}

	// 使用FFT计算f(x)的三角插值多项式的系数
	coefficients := FFT(samples)

	// 打印结果
	fmt.Println(coefficients)
}