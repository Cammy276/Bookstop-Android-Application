DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS feedbacks;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS shelves;
DROP TABLE IF EXISTS shelf_books;
DROP TABLE IF EXISTS view_record;

CREATE TABLE IF NOT EXISTS users (
    user_id INTEGER PRIMARY KEY AUTOINCREMENT,
    username TEXT UNIQUE NOT NULL,
    email TEXT NOT NULL,
    password TEXT NOT NULL,
    phone_number TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS feedbacks (
    feedback_id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    feedback_type TEXT NOT NULL,
    feedback_description TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS messages (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    room_id INTEGER NOT NULL, -- at where, essentially = book_id
    user_id INTEGER NOT NULL, -- sent by who
    msg TEXT NOT NULL,
    timestamp TEXT NOT NULL DEFAULT (datetime('now')),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

CREATE TABLE IF NOT EXISTS shelves (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE (user_id, name) --user cannot have mult shelf with same name
);

CREATE TABLE IF NOT EXISTS shelf_books (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    shelf_id INTEGER NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (shelf_id) REFERENCES shelves(id),
    UNIQUE (user_id, book_id, shelf_id)
);

CREATE TABLE IF NOT EXISTS view_record (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    viewed_at TEXT DEFAULT (datetime('now')),
    progress INTEGER DEFAULT(0) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    UNIQUE (user_id, book_id)
);

INSERT INTO shelves (user_id, name) VALUES
(1, 'Favorites'),
(2, 'To Read'),
(3, 'Finished');

INSERT INTO shelf_books (user_id, book_id, shelf_id) VALUES
(1, 101, 1),
(2, 102, 2),
(3, 103, 3);

INSERT INTO messages (room_id, user_id, msg, timestamp) VALUES
(101, 1, 'Just finished reading this book!', '2025-05-10 10:00:00'),
(101, 2, 'What did you think of the ending?', '2025-05-10 10:05:00'),
(102, 3, 'This book is on my list!', '2025-05-10 10:10:00');

INSERT INTO feedbacks (user_id, feedback_type, feedback_description) VALUES
(1, 'Bug', 'The app crashes when I add a new shelf.'),
(2, 'Suggestion', 'Can we have dark mode?');

INSERT INTO view_record (user_id, book_id) VALUES
(1, 101),
(2, 102),
(3, 103);