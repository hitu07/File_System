
--1. Create the Table--

     CREATE TABLE FileSystem (
    id INT PRIMARY KEY IDENTITY(1,1),
    name VARCHAR(255) NOT NULL,
    parent_id INT NULL,
    type VARCHAR(10) CHECK (type IN ('file', 'directory')),
    FOREIGN KEY (parent_id) REFERENCES FileSystem(id)
);

--2. Insert Root Directory --

    INSERT INTO FileSystem (name, parent_id, type)
VALUES ('root', NULL, 'directory');

--3. Insert Some Files and Directories --

    -- Add 'docs' directory under root
INSERT INTO FileSystem (name, parent_id, type)
VALUES ('docs', 1, 'directory');

-- Add 'file1.txt' under root
INSERT INTO FileSystem (name, parent_id, type)
VALUES ('file1.txt', 1, 'file');

-- Add 'notes.txt' under docs
INSERT INTO FileSystem (name, parent_id, type)
VALUES ('notes.txt', 2, 'file');


--4.Search for a File/Directory --

 SELECT * FROM FileSystem
WHERE name = 'notes.txt';


--5.Delete a File--

  DELETE FROM FileSystem
WHERE name = 'file1.txt' AND type = 'file';

--6.List Contents of a Directory--

SELECT * FROM FileSystem
WHERE parent_id = 1;

--7.Display Tree Hierarchy--

WITH FileTree AS (
    SELECT id, name, parent_id, type, CAST(name AS VARCHAR(MAX)) AS path, 0 AS level
    FROM FileSystem
    WHERE parent_id IS NULL

    UNION ALL

    SELECT fs.id, fs.name, fs.parent_id, fs.type,
           CAST(ft.path + ' / ' + fs.name AS VARCHAR(MAX)),
           level + 1
    FROM FileSystem fs
    JOIN FileTree ft ON fs.parent_id = ft.id
)
SELECT REPLICATE('   ', level) + CASE WHEN type = 'directory' THEN '[D] ' ELSE '[F] ' END + name AS Tree
FROM FileTree
ORDER BY path;
