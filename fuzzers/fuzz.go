package main

import (
	"os"
	"github.com/hashicorp/hcl/hclsimple"
)

type Config struct {
	LogLevel string `hcl:"log_level"`
}

func main() {
	var config Config
	err := hclsimple.DecodeFile(os.Args[1], nil, &config)
	if err != nil {
		return 
  }
}
