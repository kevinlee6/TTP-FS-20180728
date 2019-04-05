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
-- Name: transaction_method; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.transaction_method AS ENUM (
    'buy',
    'sell'
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: owned_shares; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.owned_shares (
    id bigint NOT NULL,
    portfolio_id bigint,
    ticker character varying NOT NULL,
    num_shares integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: owned_shares_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.owned_shares_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: owned_shares_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.owned_shares_id_seq OWNED BY public.owned_shares.id;


--
-- Name: portfolios; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.portfolios (
    id bigint NOT NULL,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: portfolios_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.portfolios_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: portfolios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.portfolios_id_seq OWNED BY public.portfolios.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id bigint NOT NULL,
    ticker character varying NOT NULL,
    qty integer NOT NULL,
    price_per_share double precision NOT NULL,
    user_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    method public.transaction_method NOT NULL
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    cash double precision DEFAULT 5000.0,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: owned_shares id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owned_shares ALTER COLUMN id SET DEFAULT nextval('public.owned_shares_id_seq'::regclass);


--
-- Name: portfolios id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios ALTER COLUMN id SET DEFAULT nextval('public.portfolios_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: owned_shares owned_shares_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.owned_shares
    ADD CONSTRAINT owned_shares_pkey PRIMARY KEY (id);


--
-- Name: portfolios portfolios_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.portfolios
    ADD CONSTRAINT portfolios_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_owned_shares_on_portfolio_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_owned_shares_on_portfolio_id ON public.owned_shares USING btree (portfolio_id);


--
-- Name: index_portfolios_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_portfolios_on_user_id ON public.portfolios USING btree (user_id);


--
-- Name: index_transactions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_transactions_on_user_id ON public.transactions USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: transaction_method_index; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX transaction_method_index ON public.transactions USING btree (method);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20181027174945'),
('20181027180813'),
('20181027184049'),
('20181027184050'),
('20190202192844');


