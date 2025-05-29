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