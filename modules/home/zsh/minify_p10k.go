package main

import (
    "bufio"
    "fmt"
    "os"
    "regexp"
    "strings"
)

func removeComments(inputFilePath, outputFilePath string) error {
    inputFile, err := os.Open(inputFilePath)
    if err != nil {
        return err
    }
    defer inputFile.Close()

    var lines []string

    scanner := bufio.NewScanner(inputFile)
    for scanner.Scan() {
        line := scanner.Text()

        re := regexp.MustCompile(`^\s*#.*$`)
        line = re.ReplaceAllString(line, "")
        re = regexp.MustCompile(`( *)# .*`)
        line = re.ReplaceAllString(line, "")
        if strings.TrimSpace(line) != "" {
            lines = append(lines, line)
        }
    }

    if err := scanner.Err(); err != nil {
        return err
    }

    outputFile, err := os.Create(outputFilePath)
    if err != nil {
        return err
    }
    defer outputFile.Close()

    for _, line := range lines {
        fmt.Fprintln(outputFile, line)
    }

    return nil
}

func main() {
    inputFilePath := "p10k.zsh"
    outputFilePath := "p10k.minified.zsh"

    if err := removeComments(inputFilePath, outputFilePath); err != nil {
        fmt.Println("Error:", err)
        return
    }

    fmt.Println("Comments removed from " + inputFilePath + "successfully!")
    fmt.Println("Wrote file to " + outputFilePath)
}
