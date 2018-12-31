--
-- PostgreSQL database dump
--

-- Dumped from database version 10.6 (Ubuntu 10.6-1.pgdg16.04+1)
-- Dumped by pg_dump version 10.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: events; Type: TABLE; Schema: public; Owner: dxokxqvnsusoum
--

CREATE TABLE public.events (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    postcode text NOT NULL,
    lat double precision NOT NULL,
    lon double precision NOT NULL,
    date bigint NOT NULL,
    thing text
);


ALTER TABLE public.events OWNER TO dxokxqvnsusoum;

--
-- Name: things; Type: TABLE; Schema: public; Owner: dxokxqvnsusoum
--

CREATE TABLE public.things (
    id text DEFAULT public.uuid_generate_v4() NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.things OWNER TO dxokxqvnsusoum;

--
-- Name: events events_pkey; Type: CONSTRAINT; Schema: public; Owner: dxokxqvnsusoum
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_pkey PRIMARY KEY (id);


--
-- Name: things things_name_key; Type: CONSTRAINT; Schema: public; Owner: dxokxqvnsusoum
--

ALTER TABLE ONLY public.things
    ADD CONSTRAINT things_name_key UNIQUE (name);


--
-- Name: things things_pkey; Type: CONSTRAINT; Schema: public; Owner: dxokxqvnsusoum
--

ALTER TABLE ONLY public.things
    ADD CONSTRAINT things_pkey PRIMARY KEY (id);


--
-- Name: events events_thing_fkey; Type: FK CONSTRAINT; Schema: public; Owner: dxokxqvnsusoum
--

ALTER TABLE ONLY public.events
    ADD CONSTRAINT events_thing_fkey FOREIGN KEY (thing) REFERENCES public.things(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: dxokxqvnsusoum
--

REVOKE ALL ON SCHEMA public FROM postgres;
REVOKE ALL ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO dxokxqvnsusoum;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: LANGUAGE plpgsql; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON LANGUAGE plpgsql TO dxokxqvnsusoum;


--
-- PostgreSQL database dump complete
--

