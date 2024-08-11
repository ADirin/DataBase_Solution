# Assignment Title: Database Design and Implementation for an AI Research Database

## Objective
In this assignment, you will design and implement a relational database that supports an AI research database system. This system will store and manage data related to AI research papers, researchers, projects, and technological advancements. You will apply the principles and techniques of data modelling and logical database design, and then implement the design in HeidiSQL.

## Project Scenario
You have been tasked with creating a database for an AI research organization that tracks various aspects of AI advancements. The organization wants to store information about research papers, researchers, AI projects, technological innovations, and related conferences. The database should allow users to query information efficiently and support the management of the organization’s data.

## Requirements

### Entities and Attributes

- **Researchers**: Stores information about the researchers (`ResearcherID`, `Name`, `Affiliation`, `Email`, `AreaOfExpertise`).
- **Research Papers**: Stores details of AI research papers (`PaperID`, `Title`, `Abstract`, `PublicationDate`, `DOI`, `ResearcherID`).
- **AI Projects**: Tracks ongoing or completed AI projects (`ProjectID`, `ProjectName`, `StartDate`, `EndDate`, `Description`, `LeadResearcherID`).
- **Technological Innovations**: Catalogs technological advancements in AI (`InnovationID`, `InnovationName`, `Description`, `ReleaseDate`, `ProjectID`).
- **Conferences**: Stores details about conferences related to AI (`ConferenceID`, `ConferenceName`, `Location`, `Date`, `Topic`, `PaperID`).

### Relationships

- Each research paper is authored by one or more researchers.
- Each researcher can lead or participate in multiple AI projects.
- Each AI project can result in one or more technological innovations.
- Research papers can be presented at conferences.

### Normalization

Ensure that your database design is normalized up to at least the 3rd Normal Form (3NF) to avoid redundancy and maintain data integrity.

### ERD (Entity-Relationship Diagram)

Create an ERD that visually represents the entities, attributes, and relationships in your database.

### Logical Database Design

Translate your ERD into a logical database design, specifying the tables, columns, primary keys, and foreign keys.

### Database Implementation

- Implement the logical design in HeidiSQL. Create the database schema, tables, and relationships.
- Populate your tables with sample data (at least 5 entries per table) to demonstrate the functionality of your database.

### Queries

Write SQL queries to demonstrate the following:

- Retrieving all research papers by a specific researcher.
- Listing all projects led by a specific researcher.
- Displaying technological innovations related to a specific AI project.
- Finding all conferences where a specific paper was presented.
- Summarizing the number of papers published by each researcher.

### Documentation

Provide documentation that includes:

- A brief introduction to your database project.
- The ERD and logical design.
- The SQL code used to create and populate the database.
- The SQL queries written to retrieve information.
- Reflections on any challenges faced and how they were addressed.

## Submission Requirements

- **ERD Diagram**: Submit a PDF or image file of your ERD.
- **Logical Design**: Submit a document outlining your logical database design, including table structures and relationships.
- **SQL Script**: Submit the SQL script used to create and populate your database in HeidiSQL.
- **Queries**: Submit the SQL queries along with the results of running them in HeidiSQL.
- **Documentation**: Submit a report (PDF or Word) that includes your project overview, ERD, logical design, SQL code, and reflections.

## Deadline

- **Submission Date**: [Insert Deadline Date]

## Evaluation Criteria

- **Understanding of Data Modelling and Normalization**: 20%
- **Accuracy and Completeness of ERD and Logical Design**: 25%
- **Correctness and Functionality of the Implemented Database**: 25%
- **Quality and Completeness of SQL Queries**: 20%
- **Clarity and Detail of Documentation**: 10%

## Tools Required

- **HeidiSQL** (for database implementation)
- **A diagramming tool** (e.g., Lucidchart, Draw.io) for creating the ERD.
