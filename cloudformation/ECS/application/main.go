package main

import (
	"os"
	"database/sql"
	"log"
	"net/http"
	"fmt"
)

var db *sql.DB

func init() {
	tmpDB, err := sql.Open("postgres", fmt.Sprintf("host=psql user=%s dbname=books_database sslmode=disable", os.Getenv("DB_USER")))
	if err != nil {
		log.Fatal(err)
	}
	db = tmpDB
}

func main() {
	http.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("www/assets"))))

	http.HandleFunc("/", handleListBooks)
	http.HandleFunc("/book.html", handleViewBook)
	http.HandleFunc("/save", handleSaveBook)
	http.HandleFunc("/delete", handleDeleteBook)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
