SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

CREATE EXTENSION IF NOT EXISTS adminpack WITH SCHEMA pg_catalog;

COMMENT ON EXTENSION adminpack IS 'administrative functions for PostgreSQL';

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE TABLE public.comentarios (
    id bigint NOT NULL,
    data_criacao timestamp(6) without time zone NOT NULL,
    texto text NOT NULL,
    denuncia_id bigint NOT NULL,
    usuario_id bigint NOT NULL
);


ALTER TABLE public.comentarios OWNER TO app_user;

CREATE SEQUENCE public.comentarios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.comentarios_id_seq OWNER TO app_user;

ALTER SEQUENCE public.comentarios_id_seq OWNED BY public.comentarios.id;

CREATE TABLE public.denuncia_imagens (
    denuncia_id bigint NOT NULL,
    imagem character varying(255) NOT NULL
);

ALTER TABLE public.denuncia_imagens OWNER TO postgres;

CREATE TABLE public.denuncias (
    id bigint NOT NULL,
    usuario_id bigint NOT NULL,
    titulo character varying(255) NOT NULL,
    descricao text NOT NULL,
    status character varying(20) DEFAULT 'DENUNCIADO'::character varying NOT NULL,
    likes integer DEFAULT 0 NOT NULL,
    bairro character varying(100),
    data_criacao timestamp without time zone DEFAULT now() NOT NULL,
    latitude double precision,
    longitude double precision
);

ALTER TABLE public.denuncias OWNER TO postgres;

CREATE SEQUENCE public.denuncias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.denuncias_id_seq OWNER TO postgres;

ALTER SEQUENCE public.denuncias_id_seq OWNED BY public.denuncias.id;

CREATE TABLE public.likes (
    id bigint NOT NULL,
    data_criacao timestamp(6) without time zone NOT NULL,
    denuncia_id bigint NOT NULL,
    usuario_id bigint NOT NULL
);


ALTER TABLE public.likes OWNER TO app_user;

CREATE SEQUENCE public.likes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.likes_id_seq OWNER TO app_user;

ALTER SEQUENCE public.likes_id_seq OWNED BY public.likes.id;

CREATE TABLE public.locais (
    id bigint NOT NULL,
    bairro character varying(255) NOT NULL,
    quantidade_denuncias_ativas integer NOT NULL
);


ALTER TABLE public.locais OWNER TO app_user;

CREATE SEQUENCE public.locais_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locais_id_seq OWNER TO app_user;

ALTER SEQUENCE public.locais_id_seq OWNED BY public.locais.id;


CREATE TABLE public.usuarios (
    id bigint NOT NULL,
    nome character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    senha character varying(255) NOT NULL,
    role character varying(20) DEFAULT 'usuario'::character varying
);


ALTER TABLE public.usuarios OWNER TO postgres;

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO postgres;

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;

ALTER TABLE ONLY public.comentarios ALTER COLUMN id SET DEFAULT nextval('public.comentarios_id_seq'::regclass);

ALTER TABLE ONLY public.denuncias ALTER COLUMN id SET DEFAULT nextval('public.denuncias_id_seq'::regclass);

ALTER TABLE ONLY public.likes ALTER COLUMN id SET DEFAULT nextval('public.likes_id_seq'::regclass);

ALTER TABLE ONLY public.locais ALTER COLUMN id SET DEFAULT nextval('public.locais_id_seq'::regclass);

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


COPY public.comentarios (id, data_criacao, texto, denuncia_id, usuario_id) FROM stdin;
\.

COPY public.denuncia_imagens (denuncia_id, imagem) FROM stdin;
\.

COPY public.denuncias (id, usuario_id, titulo, descricao, status, likes, bairro, data_criacao, latitude, longitude) FROM stdin;
\.

COPY public.likes (id, data_criacao, denuncia_id, usuario_id) FROM stdin;
\.

COPY public.locais (id, bairro, quantidade_denuncias_ativas) FROM stdin;
\.


COPY public.usuarios (id, nome, email, senha, role) FROM stdin;
1	Administrador	admin@gmail.com	123456	admin
\.

SELECT pg_catalog.setval('public.comentarios_id_seq', 30, true);

SELECT pg_catalog.setval('public.denuncias_id_seq', 29, true);

SELECT pg_catalog.setval('public.likes_id_seq', 32, true);

SELECT pg_catalog.setval('public.locais_id_seq', 26, true);

SELECT pg_catalog.setval('public.usuarios_id_seq', 7, true);

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT comentarios_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.denuncias
    ADD CONSTRAINT denuncias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT likes_pkey PRIMARY KEY (id);


ALTER TABLE ONLY public.locais
    ADD CONSTRAINT locais_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.locais
    ADD CONSTRAINT uk_p0vyks81lafiowjlhvea57iwf UNIQUE (bairro);

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);

ALTER TABLE ONLY public.denuncia_imagens
    ADD CONSTRAINT denuncia_imagens_denuncia_id_fkey FOREIGN KEY (denuncia_id) REFERENCES public.denuncias(id) ON DELETE CASCADE;

ALTER TABLE ONLY public.denuncias
    ADD CONSTRAINT denuncias_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fk937j0fgqgi2sas8muiwowpcq FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);


ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT fkdts62yj83qe3k748cgcjvm48r FOREIGN KEY (usuario_id) REFERENCES public.usuarios(id);

ALTER TABLE ONLY public.likes
    ADD CONSTRAINT fkgkv1uum55mmvjfmk9ex5sqopr FOREIGN KEY (denuncia_id) REFERENCES public.denuncias(id);

ALTER TABLE ONLY public.comentarios
    ADD CONSTRAINT fkgtuotvee56inpd1l1o5k4kbew FOREIGN KEY (denuncia_id) REFERENCES public.denuncias(id);

GRANT ALL ON SCHEMA public TO app_user;

GRANT ALL ON TABLE public.denuncia_imagens TO app_user;

GRANT ALL ON TABLE public.denuncias TO app_user;

GRANT ALL ON SEQUENCE public.denuncias_id_seq TO app_user;

GRANT ALL ON TABLE public.usuarios TO app_user;

GRANT ALL ON SEQUENCE public.usuarios_id_seq TO app_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO app_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TYPES TO app_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO app_user;

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO app_user;
