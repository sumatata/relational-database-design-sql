--******************************************************************************
CREATE TABLE tbl_contact (
    pk_contact    VARCHAR2(38),
    applicantid   VARCHAR2(9),
    proposal_no   VARCHAR2(30),
    poc_type      CHAR(1),
    sequence      NUMBER(3),
    prefix        VARCHAR2(6),
    name          VARCHAR2(35),
    title         VARCHAR2(100),
    phone1        VARCHAR2(20),
    phone2        VARCHAR2(3),
    phone3        VARCHAR2(4),
    ext           VARCHAR2(10),
    fax1          VARCHAR2(20),
    fax2          VARCHAR2(3),
    fax3          VARCHAR2(4),
    email         VARCHAR2(50),
    organization  VARCHAR2(75),
    modify_date   DATE,
    create_date   DATE,
    country_code  NVARCHAR2(3),
    address1      VARCHAR2(75),
    address2      VARCHAR2(75),
    city          VARCHAR2(25),
    county_perish VARCHAR2(50),
    state         VARCHAR2(2),
    province      VARCHAR2(50),
    zipcode_4     VARCHAR2(4),
    zipcode_5     VARCHAR2(6),
    CONSTRAINT tbl_contact_pk PRIMARY KEY ( pk_contact )
);

CREATE TABLE tbl_state (
    st_code VARCHAR2(2) PRIMARY KEY
);

ALTER TABLE tbl_contact
    ADD CONSTRAINT fk_states FOREIGN KEY ( state )
        REFERENCES tbl_state ( st_code );

CREATE TABLE tbl_coversheet (
    proposal_no VARCHAR2(30) PRIMARY KEY
);

ALTER TABLE tbl_contact
    ADD CONSTRAINT tbl_contact_tbl_coversheet_proposal_no FOREIGN KEY ( proposal_no )
        REFERENCES tbl_coversheet ( proposal_no );

ALTER TABLE tbl_contact ENABLE CONSTRAINT tbl_contact_tbl_coversheet_proposal_no;

INSERT INTO tbl_coversheet ( proposal_no ) VALUES ( 'proposal12354' );

INSERT INTO tbl_contact (
    pk_contact,
    applicantid,
    proposal_no,
    poc_type,
    sequence,
    prefix,
    name,
    title,
    phone1,
    phone2,
    phone3,
    ext,
    fax1,
    fax2,
    fax3,
    email,
    organization,
    modify_date,
    create_date,
    country_code,
    address1,
    address2,
    city,
    county_perish,
    state,
    province,
    zipcode_4,
    zipcode_5
) VALUES ( 1,
           'applic34',
           'proposal12354',
           'p',
           1,
           'Mr.',
           'rtrr',
           'trtr',
           '5655655656',
           '565',
           '5656',
           NULL,
           NULL,
           NULL,
           NULL,
           'tr@tr.com',
           NULL,
           TO_DATE('2008-08-25 07:27:01', 'YYYY-MM-DD HH24:MI:SS'),
           TO_DATE('2008-08-25 07:27:01', 'YYYY-MM-DD HH24:MI:SS'),
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL,
           NULL );

COMMIT;
/
--******************************************************************************
ALTER TABLE tbl_contact RENAME COLUMN modify_date TO tbl_contact_updt_dt;

ALTER TABLE tbl_contact RENAME COLUMN create_date TO tbl_contact_crtd_dt;

ALTER TABLE tbl_contact MODIFY (
    tbl_contact_updt_dt NOT NULL
);

ALTER TABLE tbl_contact MODIFY (
    tbl_contact_crtd_dt NOT NULL
);

ALTER TABLE tbl_contact RENAME COLUMN pk_contact TO tbl_contact_id;

--******************************************************************************
-- TABLE CREATION
CREATE OR REPLACE PROCEDURE create_general_columns_in_new_table (
    source_table_name_in  VARCHAR2,
    source_column_name_in VARCHAR2,
    target_table_name_in  VARCHAR2,
    target_column_name_in VARCHAR2,
    target_data_type_in   VARCHAR2
) AS
    v_sql VARCHAR2(2000);
BEGIN
    v_sql := 'CREATE TABLE  ' || target_table_name_in;
    v_sql := v_sql || '( ';
    v_sql := v_sql
             || target_table_name_in
             || '_ID VARCHAR2(38)';
    v_sql := v_sql
             || ', '
             || target_column_name_in
             || ' '
             || target_data_type_in
             || ' NOT NULL ';

    v_sql := v_sql
             || ', '
             || target_table_name_in
             || '_CRTD_ID VARCHAR2(40) NOT NULL ';
    v_sql := v_sql
             || ', '
             || target_table_name_in
             || '_CRTD_DT DATE NOT NULL ';
    v_sql := v_sql
             || ', '
             || target_table_name_in
             || '_UPDT_ID VARCHAR2(40) NOT NULL ';
    v_sql := v_sql
             || ', '
             || target_table_name_in
             || '_UPDT_DT DATE NOT NULL ';
    v_sql := v_sql
             || ', CONSTRAINT '
             || target_table_name_in
             || '_PK PRIMARY KEY ';
    v_sql := v_sql
             || '('
             || target_table_name_in
             || '_ID) ENABLE ) ';
    EXECUTE IMMEDIATE v_sql;
END;
/

DECLARE
    source_table_name_in  VARCHAR2(200);
    source_column_name_in VARCHAR2(200);
    target_table_name_in  VARCHAR2(200);
    target_column_name_in VARCHAR2(200);
    target_data_type_in   VARCHAR2(200);
BEGIN
    source_table_name_in := 'TBL_CONTACT';
    source_column_name_in := 'PROPOSAL_NO';
    target_table_name_in := 'PROPOSAL';
    target_column_name_in := 'PROPOSAL_NO';
    target_data_type_in := 'VARCHAR2(30)';
    create_general_columns_in_new_table(
        source_table_name_in  => source_table_name_in,
        source_column_name_in => source_column_name_in,
        target_table_name_in  => target_table_name_in,
        target_column_name_in => target_column_name_in,
        target_data_type_in   => target_data_type_in
    );
--rollback; 
END;
/

-- CREATING AND CALLING TRG_02 TRIGEERS
CREATE OR REPLACE PROCEDURE prc_create_trg02_triggers (
    table_name_in  VARCHAR2,
    column_name_in VARCHAR2
) AS
    v_sql VARCHAR2(2000);
BEGIN
    v_sql := 'CREATE OR REPLACE TRIGGER trg02_'
             || table_name_in
             || ' BEFORE ';
    v_sql := v_sql
             || ' INSERT OR UPDATE ON '
             || table_name_in;
    v_sql := v_sql || ' FOR EACH ROW ';
    v_sql := v_sql || ' BEGIN';
    v_sql := v_sql || ' IF inserting THEN ';
    v_sql := v_sql
             || ' IF :NEW.'
             || column_name_in
             || ' IS NULL THEN ';
    v_sql := v_sql
             || ' :NEW.'
             || column_name_in
             || ' := SYS_GUID();';
    v_sql := v_sql || ' END IF;';
    v_sql := v_sql || ' END IF;';
    v_sql := v_sql || ' IF UPDATING THEN';
    v_sql := v_sql
             || ' :NEW.'
             || column_name_in
             || ' := :OLD.'
             || column_name_in
             || ';';

    v_sql := v_sql || ' END IF;';
    v_sql := v_sql || ' END;';
    EXECUTE IMMEDIATE v_sql;
END;
/

BEGIN
    prc_create_trg02_triggers('PROPOSAL', 'PROPOSAL_ID');
END;
/

-- INSERTING DISTINCT VALUES
INSERT INTO proposal (
    proposal_no,
    proposal_crtd_id,
    proposal_crtd_dt,
    proposal_updt_id,
    proposal_updt_dt
)
    SELECT DISTINCT
        proposal_no,
        user    AS proposal_crtd_id,
        sysdate AS proposal_crtd_dt,
        user    AS proposal_updt_id,
        sysdate AS proposal_updt_dt
    FROM
        tbl_contact;

COMMIT;
/

-- NEW COLUMN IN TBL_CONTACT
ALTER TABLE tbl_contact ADD (
    tbl_contact_proposal_id VARCHAR2(38)
);

-- UPDATING NEW COLUMN IN TBL_CONTACT FROM PROPOSAL_ID IN PROPOSAL USING PROPOSAL_NO
UPDATE tbl_contact t
SET
    t.tbl_contact_proposal_id = (
        SELECT
            p.proposal_id
        FROM
            proposal p
        WHERE
            p.proposal_no = t.proposal_no
    )
WHERE
    t.proposal_no IS NOT NULL;

COMMIT;
/

-- DROPPING THE COLUMN
ALTER TABLE tbl_contact DROP CONSTRAINT tbl_contact_tbl_coversheet_proposal_no;

ALTER TABLE tbl_contact DROP COLUMN proposal_no;

--SETTING UP THE FOREIGN KEY CONSTRAINTS
ALTER TABLE tbl_contact
    ADD CONSTRAINT tbl_contact_fk1 FOREIGN KEY ( tbl_contact_proposal_id )
        REFERENCES proposal ( proposal_id )

enable;
/

--GETTING AND UPDATING THE ORIGINAL CRTD_DT AND UPDT_DT FROM TBL_CONTACT
UPDATE proposal p
SET
    ( p.proposal_crtd_dt,
      p.proposal_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
            tbl_contact c
        WHERE
                c.tbl_contact_proposal_id = p.proposal_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact c
        WHERE
            c.tbl_contact_proposal_id = p.proposal_id
    );

COMMIT;
/

--CREATING AND CALLING TRG_01 TRIGGERS
CREATE OR REPLACE PROCEDURE prc_create_trg01_triggers (
    table_name_in VARCHAR2
) AS
    v_sql VARCHAR2(2000);
BEGIN
    v_sql := 'CREATE OR REPLACE TRIGGER trg01_'
             || table_name_in
             || ' '
             || 'BEFORE INSERT OR UPDATE ON '
             || table_name_in
             || ' '
             || 'FOR EACH ROW '
             || 'BEGIN '
             || '  IF inserting THEN '
             || '    IF :NEW.'
             || table_name_in
             || '_crtd_id IS NULL THEN '
             || '      :NEW.'
             || table_name_in
             || '_crtd_id := USER; '
             || '    END IF; '
             || '    IF :NEW.'
             || table_name_in
             || '_crtd_dt IS NULL THEN '
             || '      :NEW.'
             || table_name_in
             || '_crtd_dt := SYSDATE; '
             || '    END IF; '
             || '  ELSIF updating THEN '
             || '    IF :NEW.'
             || table_name_in
             || '_updt_id IS NULL THEN '
             || '      :NEW.'
             || table_name_in
             || '_updt_id := USER; '
             || '    END IF; '
             || '    IF :NEW.'
             || table_name_in
             || '_updt_dt IS NULL THEN '
             || '      :NEW.'
             || table_name_in
             || '_updt_dt := SYSDATE; '
             || '    END IF; '
             || '  END IF; '
             || 'END;';

    EXECUTE IMMEDIATE v_sql;
END;
/

BEGIN
    prc_create_trg01_triggers('PROPOSAL');
END;
/ 

--******************************************************************************
DECLARE
    source_table_name_in  VARCHAR2(200);
    source_column_name_in VARCHAR2(200);
    target_table_name_in  VARCHAR2(200);
    target_column_name_in VARCHAR2(200);
    target_data_type_in   VARCHAR2(200);
BEGIN
    source_table_name_in := 'TBL_CONTACT';
    source_column_name_in := 'APPLICANTID';
    target_table_name_in := 'applicant';
    target_column_name_in := 'applicant_ID_NO';
    target_data_type_in := 'VARCHAR2(30)';
    create_general_columns_in_new_table(
        source_table_name_in  => source_table_name_in,
        source_column_name_in => source_column_name_in,
        target_table_name_in  => target_table_name_in,
        target_column_name_in => target_column_name_in,
        target_data_type_in   => target_data_type_in
    );
--rollback; 
END;
/

BEGIN
    prc_create_trg02_triggers('applicant', 'applicant_ID');
END;
/

-- INSERTING DISTINCT VALUES
INSERT INTO applicant (
    applicant_id_no,
    applicant_crtd_id,
    applicant_crtd_dt,
    applicant_updt_id,
    applicant_updt_dt
)
    SELECT DISTINCT
        applicantid,
        user    AS applicant_crtd_id,
        sysdate AS applicant_crtd_dt,
        user    AS applicant_updt_id,
        sysdate AS applicant_updt_dt
    FROM
        tbl_contact;

COMMIT;
/

ALTER TABLE tbl_contact ADD (
    tbl_contact_applicant_id VARCHAR2(38)
);

UPDATE tbl_contact t
SET
    t.tbl_contact_applicant_id = (
        SELECT
            a.applicant_id
        FROM
            applicant a
        WHERE
            a.applicant_id_no = t.applicantid
    )
WHERE
    t.applicantid IS NOT NULL;

COMMIT;
/

ALTER TABLE tbl_contact DROP COLUMN applicantid;

ALTER TABLE tbl_contact
    ADD CONSTRAINT tbl_contact_fk2
        FOREIGN KEY ( tbl_contact_applicant_id )
            REFERENCES applicant ( applicant_id )
        ENABLE;

UPDATE applicant a
SET
    ( a.applicant_crtd_dt,
      a.applicant_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
            tbl_contact c
        WHERE
                c.tbl_contact_applicant_id = a.applicant_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact c
        WHERE
            c.tbl_contact_applicant_id = a.applicant_id
    );

COMMIT;
/

BEGIN
    prc_create_trg01_triggers('APPLICANT');
END;
/

--******************************************************************************
DECLARE
    source_table_name_in  VARCHAR2(200);
    source_column_name_in VARCHAR2(200);
    target_table_name_in  VARCHAR2(200);
    target_column_name_in VARCHAR2(200);
    target_data_type_in   VARCHAR2(200);
BEGIN
    source_table_name_in := 'TBL_CONTACT';
    source_column_name_in := 'organization';
    target_table_name_in := 'ORGANIZATION';
    target_column_name_in := 'ORGANIZATION_NAME';
    target_data_type_in := 'VARCHAR2(75)';
    create_general_columns_in_new_table(
        source_table_name_in  => source_table_name_in,
        source_column_name_in => source_column_name_in,
        target_table_name_in  => target_table_name_in,
        target_column_name_in => target_column_name_in,
        target_data_type_in   => target_data_type_in
    );
--rollback; 
END;
/

BEGIN
    prc_create_trg02_triggers('ORGANIZATION', 'ORGANIZATION_ID');
END;
/

INSERT INTO organization (
    organization_name,
    organization_crtd_id,
    organization_crtd_dt,
    organization_updt_id,
    organization_updt_dt
)
    SELECT DISTINCT
        organization,
        user,
        sysdate,
        user,
        sysdate
    FROM
        tbl_contact
    WHERE
        organization IS NOT NULL;

COMMIT;
/

ALTER TABLE tbl_contact ADD (
    tbl_contact_organization_id VARCHAR2(38)
);

UPDATE tbl_contact t
SET
    t.tbl_contact_organization_id = (
        SELECT
            o.organization_id
        FROM
            organization o
        WHERE
            o.organization_name = t.organization
    )
WHERE
    t.organization IS NOT NULL;

COMMIT;
/

ALTER TABLE tbl_contact DROP COLUMN organization;

ALTER TABLE tbl_contact
    ADD CONSTRAINT tbl_contact_fk3
        FOREIGN KEY ( tbl_contact_organization_id )
            REFERENCES organization ( organization_id )
        ENABLE;

UPDATE organization o
SET
    ( o.organization_crtd_dt,
      o.organization_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
            tbl_contact c
        WHERE
                c.tbl_contact_organization_id = o.organization_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact c
        WHERE
            c.tbl_contact_organization_id = o.organization_id
    );

COMMIT;
/

BEGIN
    prc_create_trg01_triggers('ORGANIZATION');
END;
/ 

--******************************************************************************

DECLARE
    source_table_name_in  VARCHAR2(200);
    source_column_name_in VARCHAR2(200);
    target_table_name_in  VARCHAR2(200);
    target_column_name_in VARCHAR2(200);
    target_data_type_in   VARCHAR2(200);
BEGIN
    source_table_name_in := 'TBL_CONTACT';
    source_column_name_in := 'EMAIL';
    target_table_name_in := 'EMAIL';
    target_column_name_in := 'EMAIL_ADDRESS';
    target_data_type_in := 'VARCHAR2(50)';
    create_general_columns_in_new_table(
        source_table_name_in  => source_table_name_in,
        source_column_name_in => source_column_name_in,
        target_table_name_in  => target_table_name_in,
        target_column_name_in => target_column_name_in,
        target_data_type_in   => target_data_type_in
    );
--rollback; 
END;
/

CREATE TABLE tbl_contact_email (
    tbl_contact_email_id             VARCHAR2(38) NOT NULL,
    tbl_contact_email_tbl_contact_id VARCHAR2(38) NOT NULL,
    tbl_contact_email_email_id       VARCHAR2(38) NOT NULL,
    tbl_contact_email_crtd_id        VARCHAR2(40) NOT NULL,
    tbl_contact_email_crtd_dt        DATE NOT NULL,
    tbl_contact_email_updt_id        VARCHAR2(40) NOT NULL,
    tbl_contact_email_updt_dt        DATE NOT NULL,
    CONSTRAINT tbl_contact_email_pk PRIMARY KEY ( tbl_contact_email_id ) ENABLE
);

BEGIN
    prc_create_trg02_triggers('EMAIL', 'EMAIL_ID');
END;
/

BEGIN
    prc_create_trg02_triggers('TBL_CONTACT_EMAIL', 'TBL_CONTACT_EMAIL_ID');
END;
/

INSERT INTO email (
    email_address,
    email_crtd_id,
    email_crtd_dt,
    email_updt_id,
    email_updt_dt
)
    SELECT DISTINCT
        email,
        user,
        sysdate,
        user,
        sysdate
    FROM
        tbl_contact
    WHERE
        email IS NOT NULL;

COMMIT;
/

INSERT INTO tbl_contact_email (
    tbl_contact_email_tbl_contact_id,
    tbl_contact_email_email_id,
    tbl_contact_email_crtd_id,
    tbl_contact_email_crtd_dt,
    tbl_contact_email_updt_id,
    tbl_contact_email_updt_dt
)
    SELECT DISTINCT
        t.tbl_contact_id,
        e.email_id,
        user,
        sysdate,
        user,
        sysdate
    FROM
             tbl_contact t
        JOIN email e ON t.email = e.email_address
    WHERE
        t.email IS NOT NULL;

COMMIT;
/

ALTER TABLE tbl_contact DROP COLUMN email;

ALTER TABLE tbl_contact_email
    ADD CONSTRAINT tbl_contact_email_fk1
        FOREIGN KEY ( tbl_contact_email_tbl_contact_id )
            REFERENCES tbl_contact ( tbl_contact_id )
        ENABLE;

ALTER TABLE tbl_contact_email
    ADD CONSTRAINT tbl_contact_email_fk2
        FOREIGN KEY ( tbl_contact_email_email_id )
            REFERENCES email ( email_id )
        ENABLE;

UPDATE email e
SET
    ( e.email_crtd_dt,
      e.email_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
                 tbl_contact_email tce
            JOIN tbl_contact c ON c.tbl_contact_id = tce.tbl_contact_email_tbl_contact_id
        WHERE
                tce.tbl_contact_email_email_id = e.email_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact_email tce
        WHERE
            tce.tbl_contact_email_email_id = e.email_id
    );

COMMIT;
/

UPDATE tbl_contact_email tce
SET
    ( tce.tbl_contact_email_crtd_dt,
      tce.tbl_contact_email_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
            tbl_contact c
        WHERE
                c.tbl_contact_id = tce.tbl_contact_email_tbl_contact_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact c
        WHERE
            c.tbl_contact_id = tce.tbl_contact_email_tbl_contact_id
    );

COMMIT;
/

BEGIN
    prc_create_trg01_triggers('EMAIL');
END;
/

BEGIN
    prc_create_trg01_triggers('TBL_CONTACT_EMAIL');
END;
/ 

--******************************************************************************

CREATE TABLE phone (
    phone_id      VARCHAR2(38) NOT NULL,
    phone_number  VARCHAR2(20) NOT NULL,
    phone_ext     VARCHAR2(10),
    phone_crtd_id VARCHAR2(40) NOT NULL,
    phone_crtd_dt DATE NOT NULL,
    phone_updt_id VARCHAR2(40) NOT NULL,
    phone_updt_dt DATE NOT NULL,
    CONSTRAINT phone_pk PRIMARY KEY ( phone_id ) ENABLE
);

BEGIN
    prc_create_trg02_triggers('PHONE', 'PHONE_ID');
END;
/

CREATE TABLE tbl_contact_phone (
    tbl_contact_phone_id             VARCHAR2(38) NOT NULL,
    tbl_contact_phone_tbl_contact_id VARCHAR2(38) NOT NULL,
    tbl_contact_phone_phone_id       VARCHAR2(38) NOT NULL,
    tbl_contact_phone_phone_type_id  VARCHAR2(38) NOT NULL,
    tbl_contact_phone_crtd_id        VARCHAR2(40) NOT NULL,
    tbl_contact_phone_crtd_dt        DATE NOT NULL,
    tbl_contact_phone_updt_id        VARCHAR2(40) NOT NULL,
    tbl_contact_phone_updt_dt        DATE NOT NULL,
    CONSTRAINT tbl_contact_phone_pk PRIMARY KEY ( tbl_contact_phone_id ) ENABLE
);

BEGIN
    prc_create_trg02_triggers('TBL_CONTACT_PHONE', 'TBL_CONTACT_PHONE_ID');
END;
/

CREATE TABLE phone_type (
    phone_type_id      VARCHAR2(38) NOT NULL,
    phone_type_desc    VARCHAR2(10) NOT NULL,
    phone_type_crtd_id VARCHAR2(40) NOT NULL,
    phone_type_crtd_dt DATE NOT NULL,
    phone_type_updt_id VARCHAR2(40) NOT NULL,
    phone_type_updt_dt DATE NOT NULL,
    CONSTRAINT phone_type_pk PRIMARY KEY ( phone_type_id ) ENABLE
);

BEGIN
    prc_create_trg02_triggers('phone_TYPE', 'phone_TYPE_id');
END;
/

INSERT INTO phone (
    phone_number,
    phone_crtd_id,
    phone_crtd_dt,
    phone_updt_id,
    phone_updt_dt
)
    SELECT DISTINCT
        p.phone_number,
        user,
        sysdate,
        user,
        sysdate
    FROM
        (
    -- PHONE1 + its EXT if present
            SELECT
                tc.phone1
                || nvl2(
                    nullif(
                        trim(tc.ext),
                        ''
                    ),    -- NULL if ext is empty
                    ' x' || trim(tc.ext),        -- else prepend ' x'
                    ''                           -- else add nothing
                ) AS phone_number
            FROM
                tbl_contact tc
            WHERE
                phone1 IS NOT NULL
            UNION ALL

    -- PHONE2
            SELECT
                phone2 AS phone_number
            FROM
                tbl_contact
            WHERE
                phone2 IS NOT NULL
            UNION ALL

    -- PHONE3
            SELECT
                phone3 AS phone_number
            FROM
                tbl_contact
            WHERE
                phone3 IS NOT NULL
            UNION ALL

    -- FAX1
            SELECT
                fax1 AS phone_number
            FROM
                tbl_contact
            WHERE
                fax1 IS NOT NULL
            UNION ALL

    -- FAX2
            SELECT
                fax2 AS phone_number
            FROM
                tbl_contact
            WHERE
                fax2 IS NOT NULL
            UNION ALL

    -- FAX3
            SELECT
                fax3 AS phone_number
            FROM
                tbl_contact
            WHERE
                fax3 IS NOT NULL
        ) p;

COMMIT;
/

INSERT INTO tbl_contact_phone (
    tbl_contact_phone_tbl_contact_id,
    tbl_contact_phone_phone_id,
    tbl_contact_phone_phone_type_id,
    tbl_contact_phone_crtd_id,
    tbl_contact_phone_crtd_dt,
    tbl_contact_phone_updt_id,
    tbl_contact_phone_updt_dt
)
    SELECT DISTINCT
        c.tbl_contact_id AS tbl_contact_phone_tbl_contact_id,
        p.phone_id       AS tbl_contact_phone_phone_id,
        pt.phone_type_id AS tbl_contact_phone_phone_type_id,
        user             AS tbl_contact_phone_crtd_id,
        sysdate          AS tbl_contact_phone_crtd_dt,
        user             AS tbl_contact_phone_updt_id,
        sysdate          AS tbl_contact_phone_updt_dt
    FROM
             (
    -- PHONE entries
            SELECT
                tc.tbl_contact_id          AS tbl_contact_id,
                tc.phone1
                || nvl(' x' || tc.ext, '') AS phone_number,
                'PHONE'                    AS phone_type_desc
            FROM
                tbl_contact tc
            WHERE
                tc.phone1 IS NOT NULL
            UNION ALL
            SELECT
                tc.tbl_contact_id AS tbl_contact_id,
                tc.phone2         AS phone_number,
                'PHONE'           AS phone_type_desc
            FROM
                tbl_contact tc
            WHERE
                tc.phone2 IS NOT NULL
            UNION ALL
            SELECT
                tc.tbl_contact_id AS tbl_contact_id,
                tc.phone3         AS phone_number,
                'PHONE'           AS phone_type_desc
            FROM
                tbl_contact tc
            WHERE
                tc.phone3 IS NOT NULL
            UNION ALL

    -- FAX entries
            SELECT
                tc.tbl_contact_id AS tbl_contact_id,
                tc.fax1           AS phone_number,
                'FAX'             AS phone_type_desc
            FROM
                tbl_contact tc
            WHERE
                tc.fax1 IS NOT NULL
            UNION ALL
            SELECT
                tc.tbl_contact_id AS tbl_contact_id,
                tc.fax2           AS phone_number,
                'FAX'             AS phone_type_desc
            FROM
                tbl_contact tc
            WHERE
                tc.fax2 IS NOT NULL
            UNION ALL
            SELECT
                tc.tbl_contact_id AS tbl_contact_id,
                tc.fax3           AS phone_number,
                'FAX'             AS phone_type_desc
            FROM
                tbl_contact tc
            WHERE
                tc.fax3 IS NOT NULL
        ) c
        JOIN phone      p ON p.phone_number = c.phone_number
        JOIN phone_type pt ON pt.phone_type_desc = c.phone_type_desc;

COMMIT;
/

INSERT INTO phone_type (
    phone_type_desc,
    phone_type_crtd_id,
    phone_type_crtd_dt,
    phone_type_updt_id,
    phone_type_updt_dt
)
    SELECT DISTINCT
        c.phone_type_desc AS phone_type_desc,
        user              AS phone_type_crtd_id,
        sysdate           AS phone_type_crtd_dt,
        user              AS phone_type_updt_id,
        sysdate           AS phone_type_updt_dt
    FROM
        (
            SELECT
                'PHONE' AS phone_type_desc
            FROM
                dual
            UNION ALL
            SELECT
                'FAX' AS phone_type_desc
            FROM
                dual
        ) c;

COMMIT;
/

ALTER TABLE tbl_contact_phone
    ADD CONSTRAINT tbl_contact_phone_fk1
        FOREIGN KEY ( tbl_contact_phone_tbl_contact_id )
            REFERENCES tbl_contact ( tbl_contact_id )
        ENABLE;

ALTER TABLE tbl_contact_phone
    ADD CONSTRAINT tbl_contact_phone_fk2
        FOREIGN KEY ( tbl_contact_phone_phone_id )
            REFERENCES phone ( phone_id )
        ENABLE;

ALTER TABLE tbl_contact_phone
    ADD CONSTRAINT tbl_contact_phone_fk3
        FOREIGN KEY ( tbl_contact_phone_phone_type_id )
            REFERENCES phone_type ( phone_type_id )
        ENABLE;

ALTER TABLE tbl_contact DROP COLUMN phone1;

ALTER TABLE tbl_contact DROP COLUMN phone2;

ALTER TABLE tbl_contact DROP COLUMN phone3;

ALTER TABLE tbl_contact DROP COLUMN ext;

ALTER TABLE tbl_contact DROP COLUMN fax1;

ALTER TABLE tbl_contact DROP COLUMN fax2;

ALTER TABLE tbl_contact DROP COLUMN fax3;

UPDATE phone p
SET
    ( p.phone_crtd_dt,
      p.phone_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
                 tbl_contact_phone tcp
            JOIN tbl_contact c ON c.tbl_contact_id = tcp.tbl_contact_phone_tbl_contact_id
        WHERE
                tcp.tbl_contact_phone_phone_id = p.phone_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact_phone tcp
        WHERE
            tcp.tbl_contact_phone_phone_id = p.phone_id
    );

COMMIT;
/

UPDATE tbl_contact_phone tcp
SET
    ( tcp.tbl_contact_phone_crtd_dt,
      tcp.tbl_contact_phone_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
            tbl_contact c
        WHERE
                c.tbl_contact_id = tcp.tbl_contact_phone_tbl_contact_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact c
        WHERE
            c.tbl_contact_id = tcp.tbl_contact_phone_tbl_contact_id
    );

COMMIT;
/

UPDATE phone_type pt
SET
    ( pt.phone_type_crtd_dt,
      pt.phone_type_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
                 tbl_contact_phone tcp
            JOIN tbl_contact c ON c.tbl_contact_id = tcp.tbl_contact_phone_tbl_contact_id
        WHERE
                tcp.tbl_contact_phone_phone_type_id = pt.phone_type_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact_phone tcp
        WHERE
            tcp.tbl_contact_phone_phone_type_id = pt.phone_type_id
    );

COMMIT;
/

BEGIN
    prc_create_trg01_triggers('PHONE');
END;
/

BEGIN
    prc_create_trg01_triggers('TBL_CONTACT_PHONE');
END;
/

BEGIN
    prc_create_trg01_triggers('PHONE_TYPE');
END;
/ 
--******************************************************************************
CREATE TABLE address (
    address_id            VARCHAR2(38) NOT NULL,
    address_line1         VARCHAR2(75) NOT NULL,
    address_line2         VARCHAR2(20),
    address_city          VARCHAR2(25) NOT NULL,
    address_county_perish VARCHAR2(50) NOT NULL,
    address_state         CHAR(2) NOT NULL,
    address_province      VARCHAR2(50) NOT NULL,
    address_zip_code4     VARCHAR2(4) NOT NULL,
    address_zip_code5     VARCHAR2(6) NOT NULL,
    address_country_code  NVARCHAR2(3) NOT NULL,
    address_crtd_id       VARCHAR2(40) NOT NULL,
    address_crtd_dt       DATE NOT NULL,
    address_updt_id       VARCHAR2(40) NOT NULL,
    address_updt_dt       DATE NOT NULL,
    CONSTRAINT address_pk PRIMARY KEY ( address_id ) ENABLE
);

BEGIN
    prc_create_trg02_triggers('ADDRESS', 'ADDRESS_ID');
END;
/

CREATE TABLE tbl_contact_address (
    tbl_contact_address_id              VARCHAR2(38) NOT NULL,
    tbl_contact_address_tbl_contact_id  VARCHAR2(38) NOT NULL,
    tbl_contact_address_address_id      VARCHAR2(38) NOT NULL,
    tbl_contact_address_address_type_id VARCHAR2(38) NOT NULL,
    tbl_contact_address_crtd_id         VARCHAR2(40) NOT NULL,
    tbl_contact_address_crtd_dt         DATE NOT NULL,
    tbl_contact_address_updt_id         VARCHAR2(40) NOT NULL,
    tbl_contact_address_updt_dt         DATE NOT NULL,
    CONSTRAINT tbl_contact_address_pk PRIMARY KEY ( tbl_contact_address_id ) ENABLE
);

CREATE TABLE address_type (
    address_type_id      VARCHAR2(38) NOT NULL,
    address_type_desc    VARCHAR2(10) NOT NULL,
    address_type_crtd_id VARCHAR2(40) NOT NULL,
    address_type_crtd_dt DATE NOT NULL,
    address_type_updt_id VARCHAR2(40) NOT NULL,
    address_type_updt_dt DATE NOT NULL,
    CONSTRAINT address_type_pk PRIMARY KEY ( address_type_id ) ENABLE
);

BEGIN
    prc_create_trg02_triggers('TBL_CONTACT_ADDRESS', 'TBL_CONTACT_ADDRESS_ID');
END;
/

BEGIN
    prc_create_trg02_triggers('ADDRESS_TYPE', 'ADDRESS_TYPE_id');
END;
/

INSERT INTO address (
    address_line1,
    address_line2,
    address_city,
    address_county_perish,
    address_state,
    address_province,
    address_zip_code4,
    address_zip_code5,
    address_country_code,
    address_crtd_id,
    address_crtd_dt,
    address_updt_id,
    address_updt_dt
)
    SELECT DISTINCT
        addr.address_line1         AS address_line1,
        addr.address_line2         AS address_line2,
        addr.address_city          AS address_city,
        addr.address_county_perish AS address_county_perish,
        addr.address_state         AS address_state,
        addr.address_province      AS address_province,
        addr.address_zip_code4     AS address_zip_code4,
        addr.address_zip_code5     AS address_zip_code5,
        addr.address_country_code  AS address_country_code,
        user                       AS address_crtd_id,
        sysdate                    AS address_crtd_dt,
        user                       AS address_updt_id,
        sysdate                    AS address_updt_dt
    FROM
        (
            SELECT
                tc.address1      AS address_line1,
                tc.address2      AS address_line2,
                tc.city          AS address_city,
                tc.county_perish AS address_county_perish,
                tc.state         AS address_state,
                tc.province      AS address_province,
                tc.zipcode_4     AS address_zip_code4,
                tc.zipcode_5     AS address_zip_code5,
                tc.country_code  AS address_country_code
            FROM
                tbl_contact tc
            WHERE
                tc.address1 IS NOT NULL
                OR tc.address2 IS NOT NULL
                OR tc.city IS NOT NULL
                OR tc.county_perish IS NOT NULL
                OR tc.state IS NOT NULL
                OR tc.province IS NOT NULL
                OR tc.zipcode_4 IS NOT NULL
                OR tc.zipcode_5 IS NOT NULL
                OR tc.country_code IS NOT NULL
        ) addr;

COMMIT;
/

INSERT INTO tbl_contact_address (
    tbl_contact_address_tbl_contact_id,
    tbl_contact_address_address_id,
    tbl_contact_address_crtd_id,
    tbl_contact_address_crtd_dt,
    tbl_contact_address_updt_id,
    tbl_contact_address_updt_dt
)
    SELECT DISTINCT
        t.tbl_contact_id AS tbl_contact_address_tbl_contact_id,
        a.address_id     AS tbl_contact_address_address_id,
        user             AS tbl_contact_address_crtd_id,
        sysdate          AS tbl_contact_address_crtd_dt,
        user             AS tbl_contact_address_updt_id,
        sysdate          AS tbl_contact_address_updt_dt
    FROM
             tbl_contact t
        JOIN address a ON nvl(a.address_line1, '') = nvl(t.address1, '')
                          AND nvl(a.address_line2, '') = nvl(t.address2, '')
                          AND nvl(a.address_city, '') = nvl(t.city, '')
                          AND nvl(a.address_county_perish, '') = nvl(t.county_perish, '')
                          AND nvl(a.address_state, '') = nvl(t.state, '')
                          AND nvl(a.address_province, '') = nvl(t.province, '')
                          AND nvl(a.address_zip_code4, '') = nvl(t.zipcode_4, '')
                          AND nvl(a.address_zip_code5, '') = nvl(t.zipcode_5, '')
                          AND nvl(a.address_country_code, '') = nvl(t.country_code, '')
    WHERE
        t.address1 IS NOT NULL
        OR t.address2 IS NOT NULL
        OR t.city IS NOT NULL
        OR t.county_perish IS NOT NULL
        OR t.state IS NOT NULL
        OR t.province IS NOT NULL
        OR t.zipcode_4 IS NOT NULL
        OR t.zipcode_5 IS NOT NULL
        OR t.country_code IS NOT NULL;

COMMIT;
/

INSERT INTO address_type (
    address_type_desc,
    address_type_crtd_id,
    address_type_crtd_dt,
    address_type_updt_id,
    address_type_updt_dt
)
    SELECT DISTINCT
        t.address_type_desc AS address_type_desc,
        user                AS address_type_crtd_id,
        sysdate             AS address_type_crtd_dt,
        user                AS address_type_updt_id,
        sysdate             AS address_type_updt_dt
    FROM
        (
    -- SEEDING THE 'HOME' AS EXAMPLE TYPE AS WE DONT HAVE ANY INSERT VALUES
            SELECT
                'HOME' AS address_type_desc
            FROM
                dual
        ) t;

COMMIT;
/

ALTER TABLE tbl_contact_address
    ADD CONSTRAINT tbl_contact_address_fk1
        FOREIGN KEY ( tbl_contact_address_tbl_contact_id )
            REFERENCES tbl_contact ( tbl_contact_id )
        ENABLE;

ALTER TABLE tbl_contact_address
    ADD CONSTRAINT tbl_contact_address_fk2
        FOREIGN KEY ( tbl_contact_address_address_id )
            REFERENCES address ( address_id )
        ENABLE;

ALTER TABLE tbl_contact_address
    ADD CONSTRAINT tbl_contact_address_fk3
        FOREIGN KEY ( tbl_contact_address_address_type_id )
            REFERENCES address_type ( address_type_id )
        ENABLE;

ALTER TABLE tbl_contact DROP CONSTRAINT fk_states;

ALTER TABLE tbl_contact DROP COLUMN country_code;

ALTER TABLE tbl_contact DROP COLUMN address1;

ALTER TABLE tbl_contact DROP COLUMN address2;

ALTER TABLE tbl_contact DROP COLUMN city;

ALTER TABLE tbl_contact DROP COLUMN county_perish;

ALTER TABLE tbl_contact DROP COLUMN state;

ALTER TABLE tbl_contact DROP COLUMN province;

ALTER TABLE tbl_contact DROP COLUMN zipcode_4;

ALTER TABLE tbl_contact DROP COLUMN zipcode_5;

UPDATE address a
SET
    ( a.address_crtd_dt,
      a.address_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
                 tbl_contact_address tca
            JOIN tbl_contact c ON c.tbl_contact_id = tca.tbl_contact_address_tbl_contact_id
        WHERE
                tca.tbl_contact_address_address_id = a.address_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact_address tca
        WHERE
            tca.tbl_contact_address_address_id = a.address_id
    );

COMMIT;
/

UPDATE tbl_contact_address tca
SET
    ( tca.tbl_contact_address_crtd_dt,
      tca.tbl_contact_address_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
            tbl_contact c
        WHERE
                c.tbl_contact_id = tca.tbl_contact_address_tbl_contact_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact c
        WHERE
            c.tbl_contact_id = tca.tbl_contact_address_tbl_contact_id
    );

COMMIT;
/

UPDATE address_type at
SET
    ( at.address_type_crtd_dt,
      at.address_type_updt_dt ) = (
        SELECT
            c.tbl_contact_crtd_dt,
            c.tbl_contact_updt_dt
        FROM
                 tbl_contact_address tca
            JOIN tbl_contact c ON c.tbl_contact_id = tca.tbl_contact_address_tbl_contact_id
        WHERE
                tca.tbl_contact_address_address_type_id = at.address_type_id
            AND ROWNUM = 1
    )
WHERE
    EXISTS (
        SELECT
            1
        FROM
            tbl_contact_address tca
        WHERE
            tca.tbl_contact_address_address_type_id = at.address_type_id
    );

COMMIT;
/

BEGIN
    prc_create_trg01_triggers('ADDRESS');
END;
/

BEGIN
    prc_create_trg01_triggers('TBL_CONTACT_ADDRESS');
END;
/

BEGIN
    prc_create_trg01_triggers('ADDRESS_TYPE');
END;
/ 

--******************************************************************************
ALTER TABLE tbl_contact ADD (
    tbl_contact_crtd_id VARCHAR2(40),
    tbl_contact_updt_id VARCHAR2(40)
);

UPDATE tbl_contact
SET
    tbl_contact_crtd_id = user,
    tbl_contact_updt_id = user;

COMMIT;
/

ALTER TABLE tbl_contact MODIFY (
    tbl_contact_crtd_id NOT NULL,
    tbl_contact_updt_id NOT NULL
);

BEGIN
    prc_create_trg02_triggers('TBL_CONTACT', 'TBL_CONTACT_ID');
END;
/

BEGIN
    prc_create_trg01_triggers('TBL_CONTACT');
END;
/
--******************************************************************************