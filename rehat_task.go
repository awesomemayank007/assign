package main
import (
  "bufio"
  "fmt"
  "log"
  "os"
  "sort"
)

func main() {
  WordbyWordScan()
}
func duplicate_count(list []string) map[string]int {
  duplicate_word_fq := make(map[string]int)
  for _, item := range list {
    _, exist := duplicate_word_fq[item]
    if exist {
      duplicate_word_fq[item] += 1 // increase counter by 1 if already in the map
    } else {
      duplicate_word_fq[item] = 1 // else start counting from 1
    }
  }
  return duplicate_word_fq
}


func WordbyWordScan() {
//  var tmp string      
  var result []string
  file, err := os.Open("sample_data.txt")
  if err != nil {
    log.Fatal(err)
  }
  defer file.Close()
  scanner := bufio.NewScanner(file)
  scanner.Split(bufio.ScanWords)
//  fmt.Println("before inside loop result stores = ",result)
  for scanner.Scan() {
  result = append(result,scanner.Text())
//    fmt.Println("inside loop line stores = ",tmp)
//    fmt.Println("inside loop result stores = ",result)
  }
//  fmt.Println("before sort outside loop result stores = ",result)
  sort.Strings(result) 

// fmt.Println("after sort outside loop result stores = ",result)
// calling duplicate_count function to cound duplicate words in map
  duplicate_map := duplicate_count(result)
// sort according to values start
  n := map[int][]string{} 
  var a []int
  for k, v := range duplicate_map {
	  n[v] = append(n[v], k)
  }
  for k := range n {
	  a = append(a, k)
  }
  sort.Sort(sort.IntSlice(a))
  for _, k := range a {
	  for _, s := range n[k] {
		  fmt.Printf("%d, %s\n", k, s)
	  }
  }
  // sort according to values complete
  if err := scanner.Err(); err != nil {
    log.Fatal(err)
  }
}
