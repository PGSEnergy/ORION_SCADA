CREATE TABLE general_info (
    A_Customer    VARCHAR(255),
    A_Site        VARCHAR(255),
    A_Revision    VARCHAR(255),
    A_System_ID   VARCHAR(255)
);

create table p_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_ZT   DATETIME,
    A_GC   VARCHAR(255),
    A_GT   SHORT,
    A_LF   VARCHAR(255)
);

create table p_ix_obj (
    A_LN   VARCHAR(63),
    A_IX   SHORT,
    A_PT   SHORT,
    A_ZT   DATETIME,
    A_CX   VARCHAR(255),
    A_OI   VARCHAR(63),
    A_OX   VARCHAR(255),
    A_DX   VARCHAR(64),
    A_OA   LONG,
    A_OB   SHORT,
    A_OT   SHORT,
    A_UN   SHORT,
    A_IU   SHORT,
    A_SS   SHORT,
    A_BC   SHORT,
    A_SC   SINGLE,
    A_SN   VARCHAR(63),
    A_ST   VARCHAR(63),
    A_HI   SINGLE,
    A_HO   SINGLE,
    A_HW   SINGLE,
    A_LI   SINGLE,
    A_LO   SINGLE,
    A_LW   SINGLE,
    A_SZ   SHORT,
    A_ZE   SHORT,
    A_ZD   SINGLE,
    A_AG   SHORT,
    A_LA   SHORT,
    A_NV   SHORT,
    A_AC   SHORT,
    A_AD   LONG,
    A_PD   LONG,
    A_PI   VARCHAR(255),
    A_RC   SHORT,
    A_AA   SHORT,
    A_AE   SHORT,
    A_AF   SHORT,
    A_AH   SHORT,
    A_AN   VARCHAR(63),
    A_EE   SHORT,
    A_TH   SINGLE,
    A_CA   VARCHAR(2),
    A_HA   SHORT,
    A_HE   SHORT,
    A_HF   SHORT,
    A_HH   SHORT,
    A_HL   LONG,
    A_LD   LONG,
    A_PA   SHORT,
    A_PF   VARCHAR(255),
    A_PH   SHORT,
    A_PU   SHORT,
    A_CE   SHORT,
    A_CL   LONG,
    A_FI   LONG,
    A_FX   VARCHAR(63),
    A_RI   LONG,
    A_RX   VARCHAR(30),
    constraint A_KEY primary key (A_LN, A_IX)
);

create table p_ix_obj_addresses (
    A_LN      VARCHAR(63),
    A_IX      SHORT,
    A_IDX     SHORT,
    A_LABEL   VARCHAR(64),
    A_VALUE   LONG,
    constraint A_KEY primary key (A_LN, A_IX, A_IDX),
    constraint P_IX_ADDRESSES foreign key (A_LN, A_IX)
      references p_ix_obj (A_LN, A_IX)
);

create table p_ix_obj_activated (
    A_LN      VARCHAR(63),
    A_IX      SHORT,
    A_IDX     SHORT,
    A_NAME    VARCHAR(63),
    A_TYPE    CHAR(1),
    constraint A_KEY primary key (A_LN, A_IX, A_IDX),
    constraint P_IX_ACTIVATED foreign key (A_LN, A_IX)
      references p_ix_obj (A_LN, A_IX)
);

create table d_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_CM   VARCHAR(255),
    A_IU   SHORT,
    A_ZT   DATETIME,
    A_VT   VARCHAR(7),
    A_VL   SHORT,
    A_IN   VARCHAR(255),
    A_LF   SHORT,
    A_PS   SINGLE,
    A_SR   VARCHAR(63),
    A_TS   SHORT,
    A_EP   SHORT,
    A_PE   SHORT,
    A_PQ   SHORT,
    A_SE   SHORT,
    A_TC   VARCHAR(63),
    A_HN   SHORT,
    A_HR   LONG,
    A_LR   LONG,
    A_MO   SHORT,
    A_FI   LONG,
    A_FX   VARCHAR(255)

);

create table h_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_ZT   DATETIME,
    A_VL   LONG,
    A_VC   LONG,
    A_VF   VARCHAR(255),
    A_CX   VARCHAR(255)

);

create table h_obj_st (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_ST      VARCHAR(255),
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint C_st_LN foreign key (A_LN) references h_obj (A_LN)
);

create table h_obj_mt (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_MT      VARCHAR(255),
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint C_mt_LN foreign key (A_LN) references h_obj (A_LN)
);

create table h_obj_vc (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_VVC      VARCHAR(255),
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint C_vvc_LN foreign key (A_LN) references h_obj (A_LN)
);

create table c_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_CM   VARCHAR(255),
    A_IU   SHORT,
    A_ZT   DATETIME,
    A_EP   SHORT,
    A_PE   SHORT,
    A_PQ   SHORT,
    A_SE   SHORT,
    A_TC   VARCHAR(63),
    A_HN   SHORT,
    A_MO   SHORT,
    A_FI   LONG,
    A_FX   VARCHAR(255)

);

create table c_obj_in (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_IN      VARCHAR(255),
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint C_LN foreign key (A_LN) references c_obj (A_LN)
);

create table x_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_SA   SHORT,
    A_ZT   DATETIME
);

create table x_obj_sc (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_SC      SINGLE,
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint X_LN foreign key (A_LN) references x_obj (A_LN)
);

create table t_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_ZT   DATETIME,
    A_IU   SHORT,
    A_CDI  VARCHAR(255),
    A_CDE  VARCHAR(255),
    A_CYI  LONG,
    A_CYE  LONG,
    A_SUI  SHORT,
    A_SUE  SHORT,
    A_SYI  DATETIME,
    A_SYE  DATETIME,
    A_PE   SHORT,
    A_PQ   SHORT,
    A_SX   SHORT,
    A_CM   VARCHAR(255)
);

create table t_obj_activated (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_NAME    VARCHAR(63),
    A_TYPE    CHAR(1),
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint T_LN foreign key (A_LN) references t_obj (A_LN)
);

create table a_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_CM   VARCHAR(255),
    A_ZT   DATETIME,
    A_ON    VARCHAR(63),
    A_OT    CHAR(1)
);

create table a_obj_activated (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_SN      VARCHAR(63),
    A_ST      CHAR(1),
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint A_LN foreign key (A_LN) references a_obj (A_LN)
);

create table a_obj_activating (
    A_LN      VARCHAR(63),
    A_IDX     SHORT,
    A_NAME    VARCHAR(63),
    A_IX      SHORT,
    A_AA      SHORT,
    A_AF      SHORT,
    A_AH      SHORT,
    constraint A_KEY primary key (A_LN, A_IDX),
    constraint AP_LN foreign key (A_LN) references a_obj (A_LN)
);

CREATE TABLE f_obj (
    A_LN   VARCHAR(63) constraint A_KEY primary key,
    A_PT   SHORT,
    A_OV   VARCHAR(2),
    A_CX   VARCHAR(255),
    A_NA   SHORT,
    A_ZT   DATETIME
);

CREATE TABLE f_obj_attrs (
    A_LN   VARCHAR(63),
    A_AN   CHAR(2),
    A_AI   SHORT,
    A_AT   VARCHAR(15),
    A_AL   LONG,
    A_AP   SHORT,
    A_AA   SHORT,
    A_AH   SHORT,
    A_AE   SHORT,
    A_AD   SHORT,
    A_AS   SHORT,
    A_AX   VARCHAR(255),
    A_AO   LONG,
    constraint A_KEY primary key (A_LN, A_AN),
    constraint F_LN foreign key (A_LN) references f_obj (A_LN)
);

create table u_obj (
    A_LN   VARCHAR(63),
    A_PT   SHORT,
    A_ZT   DATETIME,
    A_CX   VARCHAR(255),
    A_OI   VARCHAR(63),
    A_OX   VARCHAR(255),
    A_OA   LONG,
    A_OB   SHORT,
    A_OT   SHORT,
    A_UN   SHORT,
    A_IU   SHORT,
    A_SS   SHORT,
    A_AC   SHORT,
    A_AD   LONG,
    A_PD   LONG,
    A_PI   VARCHAR(255),
    A_RC   SHORT,
    A_AA   SHORT,
    A_AE   SHORT,
    A_AF   SHORT,
    A_AH   SHORT,
    A_AN   VARCHAR(63),
    A_EE   SHORT,
    A_HA   SHORT,
    A_HE   SHORT,
    A_HF   SHORT,
    A_HH   SHORT,
    A_HL   LONG,
    A_LD   LONG,
    A_PA   SHORT,
    A_PF   VARCHAR(255),
    A_PH   SHORT,
    A_PU   SHORT,
    A_FI   LONG,
    A_FX   VARCHAR(63),
    A_RI   LONG,
    A_RX   VARCHAR(30),
    constraint A_KEY primary key (A_LN)
);

create table u_obj_user_attrs (
    A_LN       VARCHAR(63),
    A_AN       CHAR(2),
    A_IDX      SHORT,
    A_VALUE    VARCHAR(255),
    constraint A_KEY primary key (A_LN, A_AN, A_IDX),
    constraint U_LN foreign key (A_LN) references u_obj (A_LN)
);


CREATE TABLE picture_texts (
       a_id               CHAR(16),
       a_idx              SHORT,
       a_txt              VARCHAR(255),
       CONSTRAINT XPKpicture_texts 
              PRIMARY KEY (a_id, a_idx)
);


CREATE TABLE pictures (
       a_name             VARCHAR(255),
       a_comment          VARCHAR(68),
       a_modification_time DATETIME,
       a_width            SHORT,
       a_height           SHORT,
       CONSTRAINT XPKpictures 
              PRIMARY KEY (a_name)
);


CREATE TABLE picture_quadrants (
       a_name             VARCHAR(255),
       a_idx              SHORT,
       a_txt              VARCHAR(255),
       CONSTRAINT XPKpicture_quadrants 
              PRIMARY KEY (a_name, a_idx), 
       CONSTRAINT XFKpicture_quadrants
              FOREIGN KEY (a_name)
                     REFERENCES pictures  (a_name)
);

CREATE INDEX XIF15picture_quadrants ON picture_quadrants
(
       a_name
);


CREATE TABLE picture_functions (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(63),
       a_tool             VARCHAR(255),
       a_standard_function VARCHAR(255),
       a_x                SHORT,
       a_y                SHORT,
       a_width            SHORT,
       a_height           SHORT,
       a_under            SHORT,
       a_edit_mask        LONG,
       CONSTRAINT XPKpicture_functions 
              PRIMARY KEY (a_name, a_function_name),
       CONSTRAINT XFKpicture_functions
              FOREIGN KEY (a_name)
                     REFERENCES pictures (a_name)
);


CREATE TABLE picture_windows (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_window_name      VARCHAR(10),
       a_x                SHORT,
       a_y                SHORT,
       a_type             VARCHAR(20),
       a_representation   VARCHAR(255),
       a_expression       VARCHAR(255),
       CONSTRAINT XPKpicture_windows 
              PRIMARY KEY (a_name, a_function_name, a_window_name),
       CONSTRAINT XFKpicture_windows
              FOREIGN KEY (a_name, a_function_name)
                     REFERENCES picture_functions (a_name, a_function_name)
);


CREATE TABLE picture_window_extensions (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_window_name      VARCHAR(10),
       a_type             VARCHAR(10),
       a_direction        VARCHAR(10),
       a__count           LONG,
       a_space            LONG,
       a_points           LONG,
       CONSTRAINT XPKpicture_window_exts 
              PRIMARY KEY (a_name, a_function_name, a_window_name), 
       CONSTRAINT XFKpicture_window_exts
              FOREIGN KEY (a_name, a_function_name, a_window_name)
                     REFERENCES picture_windows  (a_name, a_function_name, a_window_name)
);


CREATE TABLE picture_window_limits (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_window_name      VARCHAR(10),
       a_idx              SHORT,
       a_limit            VARCHAR(255),
       CONSTRAINT XPKpicture_window_limits 
              PRIMARY KEY (a_name, a_function_name, a_window_name, a_idx), 
       CONSTRAINT XFKpicture_window_limits
              FOREIGN KEY (a_name, a_function_name, a_window_name)
                             REFERENCES picture_window_extensions  (a_name, a_function_name, a_window_name)
);


CREATE TABLE picture_window_exceptions (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_window_name      VARCHAR(10),
       a_idx              SHORT,
       a_is_programmable  SHORT,
       a_condition        VARCHAR(255),
       a_action           VARCHAR(20),
       a_position         VARCHAR(10),
       a_text             VARCHAR(255),
       a_background_color SHORT,
       a_foreground_color SHORT,
       a_blinking         SHORT,
       a_representation   VARCHAR(255),
       CONSTRAINT XPKpicture_window_exceptions 
              PRIMARY KEY (a_name, a_function_name, a_window_name, a_idx), 
       CONSTRAINT XFKpicture_window_exceptions
              FOREIGN KEY (a_name, a_function_name, a_window_name)
                             REFERENCES picture_window_extensions  (a_name, a_function_name, a_window_name)
);


CREATE TABLE picture_programs (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_program_name     VARCHAR(63),
       a_program_id       CHAR(16),
       CONSTRAINT XPKpicture_programs 
              PRIMARY KEY (a_name, a_function_name, a_program_name)
);


CREATE TABLE picture_function_keys (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_id               LONG,
       a_x                SHORT,
       a_y                SHORT,
       a_width            SHORT,
       a_height           SHORT,
       a_type             VARCHAR(20),
       a_blinking         SHORT,
       CONSTRAINT XPKpicture_function_keys 
              PRIMARY KEY (a_name, a_function_name, a_id)
);


CREATE TABLE picture_fk_programs (
       a_name             VARCHAR(255),
       a_function_name    VARCHAR(10),
       a_id               LONG,
       a_program_name     VARCHAR(20),
       a_program_id       CHAR(16),
       CONSTRAINT XPKpicture_fk_programs
              PRIMARY KEY (a_name, a_function_name, a_id, a_program_name),
       CONSTRAINT XFKpicture_fk_programs
              FOREIGN KEY (a_name, a_function_name, a_id)
                     REFERENCES picture_function_keys (a_name, a_function_name, a_id)
);

CREATE TABLE picture_exec_order (
       a_name             VARCHAR(255),
       a_idx              SHORT,
       a_function_name    VARCHAR(30),
       CONSTRAINT XPKpicture_exec_order 
              PRIMARY KEY (a_name, a_idx), 
       CONSTRAINT XFKpicture_exec_order
              FOREIGN KEY (a_name)
                             REFERENCES pictures  (a_name)
);


CREATE TABLE representations (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_type               VARCHAR(20),
       CONSTRAINT XPKrepresentations 
              PRIMARY KEY (a_library_name, a_ln)
);

CREATE INDEX XIFrepresentations ON representations
(
       a_type
);


CREATE TABLE representation_multifield (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_width              SHORT,
       a_decimals           SHORT,
       a_alignment          VARCHAR(10),
       a_background_color   SHORT,
       a_foreground_color   SHORT,
       a_blinking           SHORT,
       CONSTRAINT XPKrepresentations_multifield 
              PRIMARY KEY (a_library_name, a_ln), 
       CONSTRAINT XFKrepresentations_multifield
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representations  (a_library_name, a_ln)
);


CREATE TABLE representation_exceptions (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_idx                SHORT,
       a_is_programmable    SHORT,
       a_condition          VARCHAR(255),
       a_action             VARCHAR(20),
       a_position           VARCHAR(10),
       a_text               VARCHAR(255),
       a_background_color   SHORT,
       a_foreground_color   SHORT,
       a_blinking           SHORT,
       a_representation     VARCHAR(255),
       CONSTRAINT XPKrepresentation_exceptions 
              PRIMARY KEY (a_library_name, a_ln, a_idx), 
       CONSTRAINT XFKrepresentation_exceptions 
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representation_multifield  (a_library_name, a_ln)
);


CREATE TABLE representation_bar_curve (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_width              SHORT,
       a_height             SHORT,
       a_base               SINGLE,
       a_min                SINGLE,
       a_max                SINGLE,
       CONSTRAINT XPKrepresentations_bar_curve 
              PRIMARY KEY (a_library_name, a_ln), 
       CONSTRAINT XFKrepresentations_bar_curve 
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representations  (a_library_name, a_ln)
);


CREATE TABLE representation_limits (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_idx                SHORT,
       a_limit              VARCHAR(255),
       CONSTRAINT XPKrepresentation_limits 
              PRIMARY KEY (a_library_name, a_ln, a_idx), 
       CONSTRAINT XFKrepresentation_limits
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representation_bar_curve  (a_library_name, a_ln)
);


CREATE TABLE representation_bc_vectors (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_idx                SHORT,
       a_color              SHORT,
       a_color_change       SHORT,
       a_blinking           SHORT,
       CONSTRAINT XPKrepresentation_bc_vectors 
              PRIMARY KEY (a_library_name, a_ln, a_idx), 
       CONSTRAINT XFKrepresentation_bc_vectors 
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representation_bar_curve  (a_library_name, a_ln)
);


CREATE TABLE representation_background (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_idx                SHORT,
       a_txt                VARCHAR(255),
       CONSTRAINT XPKrepresentations_figure 
              PRIMARY KEY (a_library_name, a_ln, a_idx), 
       CONSTRAINT XFKrepresentations_figure 
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representations  (a_library_name, a_ln)
);


CREATE TABLE representation_field (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_value_type         VARCHAR(10),
       a_width              SHORT,
       a_decimals           SHORT,
       a_alignment          VARCHAR(10),
       a_background_color   SHORT,
       a_foreground_color   SHORT,
       a_blinking           SHORT,
       a_font               VARCHAR(40),
       a_full_bg_color      VARCHAR(20),
       a_full_fg_color      VARCHAR(20),
       CONSTRAINT XPKrepresentations_field 
              PRIMARY KEY (a_library_name, a_ln), 
       CONSTRAINT XFKrepresentations_field 
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representations  (a_library_name, a_ln)
);


CREATE TABLE representation_alternative (
       a_library_name       VARCHAR(255),
       a_ln                 VARCHAR(21),
       a_idx                SHORT,
       a_type               VARCHAR(10),
       a_representation     VARCHAR(255),
       a_condition          VARCHAR(255),
       CONSTRAINT XPKrepresentations_selector 
              PRIMARY KEY (a_library_name, a_ln, a_idx), 
       CONSTRAINT XFKrepresentations_selector 
              FOREIGN KEY (a_library_name, a_ln)
                             REFERENCES representations  (a_library_name, a_ln)
);

create table vso_main (
       A_ID             CHAR(16),
       A_FILE	         VARCHAR(255),
       A_LN		         VARCHAR(255),
       A_TYPE     	   VARCHAR(64),
       constraint A_KEY primary key (A_ID)
);

create table vso_texts (
       A_ID             CHAR(16),
       A_TEXT_ID        VARCHAR(255),
       A_LANG_ID        VARCHAR(4),
       A_TEXT           VARCHAR(255),
       constraint A_KEY primary key (A_ID, A_TEXT_ID, A_LANG_ID),
       constraint VSO_TEXTS foreign key (A_ID) references vso_main (A_ID)
);

create table vso_programs (
       A_ID             CHAR(16),
       A_PROGRAM_ID	   LONG,
       A_TYPE           VARCHAR(8),
       A_NAME           VARCHAR(64),
       A_COMMENT	      VARCHAR(255),
       constraint A_KEY primary key (A_ID, A_PROGRAM_ID),
       constraint VSO_PROGRAMS foreign key (A_ID) references vso_main (A_ID)
);

create table vso_program_texts (
       A_ID             CHAR(16),
       A_PROGRAM_ID	LONG,
       A_IDX            SHORT,
       A_TEXT           VARCHAR(255),
       constraint A_KEY primary key (A_ID, A_PROGRAM_ID, A_IDX),
       constraint VSO_PROGRAM_TEXTS foreign key (A_ID, A_PROGRAM_ID) 
                        references vso_programs (A_ID, A_PROGRAM_ID)
);
