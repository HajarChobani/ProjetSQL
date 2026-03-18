sys/sys as sysdba
CREATE USER c##projetBF IDENTIFIED BY 123;
GRANT CONNECT, RESOURCE TO c##projetBF;
ALTER USER c##projetBF QUOTA 100M ON USERS;
CONNECT c##projetBF/123;


SET SERVEROUTPUT ON
SPOOL C:\projetBF\projetBfinal.txt

-- 1. Séquences pour générer automatiquement les IDs
CREATE SEQUENCE faculty_seq START WITH 1;    -- ID pour les professeurs
CREATE SEQUENCE student_seq START WITH 1;    -- ID pour les étudiants
CREATE SEQUENCE course_seq START WITH 1;     -- ID pour les cours
CREATE SEQUENCE enrollment_seq START WITH 1; -- ID pour les inscriptions

-- 2. Tables principales
CREATE TABLE student (
    s_id NUMBER PRIMARY KEY,          -- Identifiant étudiant
    s_first VARCHAR2(50),             -- Prénom
    s_last VARCHAR2(50)               -- Nom
);

CREATE TABLE faculty (
    f_id NUMBER PRIMARY KEY,          -- Identifiant professeur
    f_first VARCHAR2(50),             -- Prénom
    f_last VARCHAR2(50)               -- Nom
);

CREATE TABLE course (
    course_id NUMBER PRIMARY KEY,     -- Identifiant cours
    course_name VARCHAR2(100)         -- Nom du cours
);

CREATE TABLE enrollment (
    s_id NUMBER REFERENCES student(s_id), -- Étudiant inscrit
    c_sec_id NUMBER,                      -- Section du cours
    grade VARCHAR2(3),                    -- Note
    PRIMARY KEY (s_id, c_sec_id)          -- Clé primaire composée
);

-- 3. Procédure pour insérer un étudiant
CREATE OR REPLACE PROCEDURE insert_student(p_first VARCHAR2, p_last VARCHAR2) AS
    v_id NUMBER;
BEGIN
    -- Générer un ID automatiquement
    v_id := student_seq.NEXTVAL;
    
    -- Insérer l'étudiant
    INSERT INTO student(s_id, s_first, s_last)
    VALUES(v_id, p_first, p_last);

    DBMS_OUTPUT.PUT_LINE('Étudiant inséré : ' || v_id);
END;
/

-- 4. Procédure pour récupérer les informations d’un étudiant (SELECT INTO)
CREATE OR REPLACE PROCEDURE get_student_info(p_s_id NUMBER) AS
    v_first student.s_first%TYPE;
    v_last  student.s_last%TYPE;
BEGIN
    SELECT s_first, s_last
    INTO v_first, v_last
    FROM student
    WHERE s_id = p_s_id;

    DBMS_OUTPUT.PUT_LINE('Étudiant : ' || v_first || ' ' || v_last);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Aucun étudiant trouvé.');
END;
/

-- 5. Fonction pour calculer l'expérience d’un professeur
CREATE OR REPLACE FUNCTION faculty_experience(p_hiredate DATE)
RETURN NUMBER AS
BEGIN
    RETURN FLOOR((SYSDATE - p_hiredate) / 365);
END;
/

-- 6. Cursor FOR loop pour afficher tous les étudiants
BEGIN
    FOR s IN (SELECT s_id, s_first, s_last FROM student) LOOP
        DBMS_OUTPUT.PUT_LINE('Étudiant : ' || s.s_first || ' ' || s.s_last);
    END LOOP;
END;
/

-- 7. Cursor avec paramètre pour rechercher un étudiant précis
CREATE OR REPLACE PROCEDURE show_student_by_id(p_s_id NUMBER) AS
BEGIN
    FOR s IN (SELECT s_id, s_first, s_last
              FROM student
              WHERE s_id = p_s_id) LOOP
        DBMS_OUTPUT.PUT_LINE('Étudiant : ' || s.s_first || ' ' || s.s_last);
    END LOOP;
END;
/

-- 8. Package pour insérer un étudiant via procédure dans le package
CREATE OR REPLACE PACKAGE school_package IS
    global_s_id NUMBER;  -- Variable globale pour ID étudiant
    PROCEDURE insert_student_pkg(p_first VARCHAR2, p_last VARCHAR2);
END;
/

CREATE OR REPLACE PACKAGE BODY school_package IS
    PROCEDURE insert_student_pkg(p_first VARCHAR2, p_last VARCHAR2) IS
    BEGIN
        global_s_id := student_seq.NEXTVAL; 
        INSERT INTO student(s_id, s_first, s_last)
        VALUES(global_s_id, p_first, p_last);
    END;
END;
/

-- 9. Trigger pour auditer les modifications dans enrollment
CREATE OR REPLACE TRIGGER enrollment_audit_trigger
AFTER INSERT OR UPDATE OR DELETE ON enrollment
FOR EACH ROW
BEGIN
    DBMS_OUTPUT.PUT_LINE('Modification dans enrollment'); 
END;
/

-- 10. Procédure surchargée pour insertion d’étudiants
CREATE OR REPLACE PROCEDURE insert_student_full(p_first VARCHAR2, p_last VARCHAR2) AS
BEGIN
    insert_student(p_first, p_last); -- Réutilisation de la procédure existante
END;
/

-- 11. User-defined Exception pour vérifier l’existence d’un étudiant
CREATE OR REPLACE PROCEDURE check_student_existence(p_s_id NUMBER) AS
    v_first student.s_first%TYPE;
    v_last  student.s_last%TYPE;
    e_not_found EXCEPTION;
BEGIN
    SELECT s_first, s_last INTO v_first, v_last
    FROM student
    WHERE s_id = p_s_id;

    DBMS_OUTPUT.PUT_LINE('Étudiant : ' || v_first || ' ' || v_last);
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE e_not_found;
    WHEN e_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Aucun étudiant trouvé avec cet ID.');
END;
/

SPOOL OFF