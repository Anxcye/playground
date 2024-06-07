package main

import (
    "fmt"
    "math"
)

// 矩阵和向量的乘积
func matVecMult(A [][]float64, x []float64) []float64 {
    result := make([]float64, len(A))
    for i := 0; i < len(A); i++ {
        sum := 0.0
        for j := 0; j < len(A[0]); j++ {
            sum += A[i][j] * x[j]
        }
        result[i] = sum
    }
    return result
}

// 向量的点积
func dotProduct(x, y []float64) float64 {
    result := 0.0
    for i := 0; i < len(x); i++ {
        result += x[i] * y[i]
    }
    return result
}

// 向量的差
func vecDiff(x, y []float64) []float64 {
    result := make([]float64, len(x))
    for i := 0; i < len(x); i++ {
        result[i] = x[i] - y[i]
    }
    return result
}

// 向量的数乘
func scalarVecMult(scalar float64, x []float64) []float64 {
    result := make([]float64, len(x))
    for i := 0; i < len(x); i++ {
        result[i] = scalar * x[i]
    }
    return result
}

// 共轭梯度法
func conjugateGradient(A [][]float64, b, x0 []float64, maxIter int, epsilon float64) []float64 {
    r := vecDiff(b, matVecMult(A, x0))
    p := r
    for i := 0; i < maxIter; i++ {
        Ap := matVecMult(A, p)
        alpha := dotProduct(r, r) / dotProduct(p, Ap)
        x0 = vecDiff(x0, scalarVecMult(-alpha, p))
        rNext := vecDiff(r, scalarVecMult(alpha, Ap))
        if math.Sqrt(dotProduct(rNext, rNext)) < epsilon {
            break
        }
        beta := dotProduct(rNext, rNext) / dotProduct(r, r)
        p = vecDiff(rNext, scalarVecMult(beta, p))
        r = rNext
    }
    return x0
}

func main() {
    A := [][]float64{{4, 1}, {1, 3}}
    b := []float64{1, 2}
    x0 := []float64{2, 1}
    maxIter := 1000
    epsilon := 1e-10
    x := conjugateGradient(A, b, x0, maxIter, epsilon)
    fmt.Println(x)
}