--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+2)
-- Dumped by pg_dump version 17.0 (Ubuntu 17.0-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.account (
    id bigint NOT NULL,
    owner character varying NOT NULL,
    balance bigint NOT NULL,
    currency character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.account OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.account_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.account_id_seq OWNER TO postgres;

--
-- Name: account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.account_id_seq OWNED BY public.account.id;


--
-- Name: entries; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.entries (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    amount bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.entries OWNER TO postgres;

--
-- Name: COLUMN entries.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.entries.amount IS 'can be negative or positive';


--
-- Name: entries_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.entries_id_seq OWNER TO postgres;

--
-- Name: entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.entries_id_seq OWNED BY public.entries.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.schema_migrations (
    version bigint NOT NULL,
    dirty boolean NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO postgres;

--
-- Name: sessions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sessions (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    username character varying NOT NULL,
    refresh_token character varying NOT NULL,
    user_agent character varying NOT NULL,
    client_ip character varying NOT NULL,
    is_blocked boolean DEFAULT false NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.sessions OWNER TO postgres;

--
-- Name: transfers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfers (
    id bigint NOT NULL,
    from_account_id bigint NOT NULL,
    to_account_id bigint NOT NULL,
    amount bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.transfers OWNER TO postgres;

--
-- Name: COLUMN transfers.amount; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.transfers.amount IS 'must be positive';


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.transfers_id_seq OWNER TO postgres;

--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.transfers.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    username character varying NOT NULL,
    hashed_password character varying NOT NULL,
    full_name character varying NOT NULL,
    email character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    password_changed_at timestamp without time zone DEFAULT '0001-01-01 00:00:00'::timestamp without time zone NOT NULL
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account ALTER COLUMN id SET DEFAULT nextval('public.account_id_seq'::regclass);


--
-- Name: entries id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries ALTER COLUMN id SET DEFAULT nextval('public.entries_id_seq'::regclass);


--
-- Name: transfers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- Name: account account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_pkey PRIMARY KEY (id);


--
-- Name: entries entries_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_pkey PRIMARY KEY (id);


--
-- Name: account owner_currency_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT owner_currency_key UNIQUE (owner, currency);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: account_owner_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX account_owner_idx ON public.account USING btree (owner);


--
-- Name: entries_account_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX entries_account_id_idx ON public.entries USING btree (account_id);


--
-- Name: transfers_from_account_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX transfers_from_account_id_idx ON public.transfers USING btree (from_account_id);


--
-- Name: transfers_from_account_id_to_account_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX transfers_from_account_id_to_account_id_idx ON public.transfers USING btree (from_account_id, to_account_id);


--
-- Name: transfers_to_account_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX transfers_to_account_id_idx ON public.transfers USING btree (to_account_id);


--
-- Name: account account_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.account
    ADD CONSTRAINT account_owner_fkey FOREIGN KEY (owner) REFERENCES public.users(username);


--
-- Name: entries entries_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.entries
    ADD CONSTRAINT entries_account_id_fkey FOREIGN KEY (account_id) REFERENCES public.account(id);


--
-- Name: sessions sessions_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sessions
    ADD CONSTRAINT sessions_username_fkey FOREIGN KEY (username) REFERENCES public.users(username);


--
-- Name: transfers transfers_from_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_from_account_id_fkey FOREIGN KEY (from_account_id) REFERENCES public.account(id);


--
-- Name: transfers transfers_to_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfers
    ADD CONSTRAINT transfers_to_account_id_fkey FOREIGN KEY (to_account_id) REFERENCES public.account(id);


--
-- PostgreSQL database dump complete
--

