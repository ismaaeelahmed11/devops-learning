// package main declares this as an executable program
// Go will start running at the main() function
package main

// import brings in the tools we need
import (
	"encoding/json" // for converting data to/from JSON
	"log"           // for printing messages to the terminal
	"net/http"      // for building a web server
)

// healthHandler runs when someone hits /health
// w = how we send data back to the client
// r = the incoming request
func healthHandler(w http.ResponseWriter, r *http.Request) {
	// tell the client we're sending JSON
	w.Header().Set("Content-Type", "application/json")
	// send {"status":"ok"} back as JSON
	json.NewEncoder(w).Encode(map[string]string{"status": "ok"})
}

// homeHandler runs when someone hits /
func homeHandler(w http.ResponseWriter, r *http.Request) {
	// send this text back to the client
	// []byte converts the string to raw bytes (Go's format)
	w.Write([]byte("Welcome to the ECS Project!"))
}

// main is the entry point — Go runs this first
func main() {
	// register /health -> healthHandler
	http.HandleFunc("/health", healthHandler)
	// register / -> homeHandler
	http.HandleFunc("/", homeHandler)

	// print a message so we know the server started
	log.Println("Starting server on port 8080")

	// start the web server on port 80
	// if it fails, log the error and stop
	if err := http.ListenAndServe(":8080", nil); err != nil {
		log.Fatal(err)
	}
}