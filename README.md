## 📚 Learning Objectives
This project aims to achieve the following learning objectives:

1. Design and implement RESTful CRUD APIs using Express.js  
2. Develop a Flutter mobile application that consumes a REST API  
3. Apply client-server architecture concepts  
4. Handle HTTP requests, responses, and JSON data  
5. Implement validation, error handling, and proper project structure  

---

## 🗂️ System Overview – NoteApp CRUD
**NoteApp** is a full-stack CRUD application that allows users to create, view, update, and delete notes.  
The system follows a **client-server architecture**, where:

- **Backend**: Express.js REST API
- **Frontend**: Flutter mobile application
- **Database**: MongoDB / MySQL

---

## ⚙️ General System Requirements Implementation

| Requirement | Implementation in NoteApp |
|-------------|---------------------------|
| Two related entities | User & Note |
| Full CRUD operations | Create, Read, Update, Delete notes |
| Database storage | Notes stored in MongoDB / MySQL |
| Client-server architecture | Flutter client + Express API |
| Realistic system | Note-taking application |

---

## 🖥️ Backend Requirements (Express.js API)

### Technologies Used
- Node.js
- Express.js
- MongoDB (Mongoose) / MySQL
- REST architecture

### Implemented Features
- RESTful API endpoints for **Notes**
- CRUD operations using:
  - `GET` – retrieve notes
  - `POST` – create notes
  - `PUT` – update notes
  - `DELETE` – delete notes
- JSON responses with correct HTTP status codes
- Basic input validation
- Centralized error handling
- Structured project layout:
