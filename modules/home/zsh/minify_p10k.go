package main

import (
    "bufio"
    "flag"
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
    var inputFilePath, outputFilePath string

    flag.StringVar(&inputFilePath, "input", "p10k.zsh", "Input file path")
    flag.StringVar(&inputFilePath, "i", "p10k.zsh", "Input file path (shorthand)")

    flag.StringVar(&outputFilePath, "output", "p10k.minified.zsh", "Output file path")
    flag.StringVar(&outputFilePath, "o", "p10k.minified.zsh", "Output file path (shorthand)")

    flag.Parse()

    if err := removeComments(inputFilePath, outputFilePath); err != nil {
        fmt.Println("Error:", err)
        os.Exit(1)
        return
    }

    fmt.Println("Comments removed from " + inputFilePath + " successfully!")
    fmt.Println("Wrote file to " + outputFilePath)
}
