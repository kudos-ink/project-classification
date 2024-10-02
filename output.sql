--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.2 (Homebrew)

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

--
-- Name: diesel_manage_updated_at(regclass); Type: FUNCTION; Schema: public; Owner: kudosadmin
--

CREATE FUNCTION public.diesel_manage_updated_at(_tbl regclass) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$;


ALTER FUNCTION public.diesel_manage_updated_at(_tbl regclass) OWNER TO kudosadmin;

--
-- Name: diesel_set_updated_at(); Type: FUNCTION; Schema: public; Owner: kudosadmin
--

CREATE FUNCTION public.diesel_set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF (
        NEW IS DISTINCT FROM OLD AND
        NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
    ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.diesel_set_updated_at() OWNER TO kudosadmin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: __diesel_schema_migrations; Type: TABLE; Schema: public; Owner: kudosadmin
--

CREATE TABLE public.__diesel_schema_migrations (
    version character varying(50) NOT NULL,
    run_on timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.__diesel_schema_migrations OWNER TO kudosadmin;

--
-- Name: issues; Type: TABLE; Schema: public; Owner: kudosadmin
--

CREATE TABLE public.issues (
    id integer NOT NULL,
    number integer NOT NULL,
    title text NOT NULL,
    labels text[],
    open boolean DEFAULT true NOT NULL,
    certified boolean,
    assignee_id integer,
    repository_id integer NOT NULL,
    issue_created_at timestamp with time zone NOT NULL,
    issue_closed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    updated_at timestamp with time zone,
    CONSTRAINT issue_closed_at_check CHECK (((issue_closed_at IS NULL) OR (issue_closed_at > issue_created_at)))
);


ALTER TABLE public.issues OWNER TO kudosadmin;

--
-- Name: issues_id_seq; Type: SEQUENCE; Schema: public; Owner: kudosadmin
--

CREATE SEQUENCE public.issues_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.issues_id_seq OWNER TO kudosadmin;

--
-- Name: issues_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kudosadmin
--

ALTER SEQUENCE public.issues_id_seq OWNED BY public.issues.id;


--
-- Name: languages; Type: TABLE; Schema: public; Owner: kudosadmin
--

CREATE TABLE public.languages (
    id integer NOT NULL,
    slug text NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.languages OWNER TO kudosadmin;

--
-- Name: languages_id_seq; Type: SEQUENCE; Schema: public; Owner: kudosadmin
--

CREATE SEQUENCE public.languages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.languages_id_seq OWNER TO kudosadmin;

--
-- Name: languages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kudosadmin
--

ALTER SEQUENCE public.languages_id_seq OWNED BY public.languages.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: kudosadmin
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    name text NOT NULL,
    slug text NOT NULL,
    types text[],
    purposes text[],
    stack_levels text[],
    technologies text[],
    avatar character varying(255),
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.projects OWNER TO kudosadmin;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: kudosadmin
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO kudosadmin;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kudosadmin
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: repositories; Type: TABLE; Schema: public; Owner: kudosadmin
--

CREATE TABLE public.repositories (
    id integer NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    url text NOT NULL,
    language_slug text NOT NULL,
    project_id integer NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    updated_at timestamp with time zone
);


ALTER TABLE public.repositories OWNER TO kudosadmin;

--
-- Name: repositories_id_seq; Type: SEQUENCE; Schema: public; Owner: kudosadmin
--

CREATE SEQUENCE public.repositories_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repositories_id_seq OWNER TO kudosadmin;

--
-- Name: repositories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kudosadmin
--

ALTER SEQUENCE public.repositories_id_seq OWNED BY public.repositories.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: kudosadmin
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username text NOT NULL,
    created_at timestamp with time zone DEFAULT (now() AT TIME ZONE 'utc'::text) NOT NULL,
    updated_at timestamp with time zone,
    avatar text
);


ALTER TABLE public.users OWNER TO kudosadmin;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: kudosadmin
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO kudosadmin;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kudosadmin
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: issues id; Type: DEFAULT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.issues ALTER COLUMN id SET DEFAULT nextval('public.issues_id_seq'::regclass);


--
-- Name: languages id; Type: DEFAULT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.languages ALTER COLUMN id SET DEFAULT nextval('public.languages_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: repositories id; Type: DEFAULT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.repositories ALTER COLUMN id SET DEFAULT nextval('public.repositories_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: __diesel_schema_migrations; Type: TABLE DATA; Schema: public; Owner: kudosadmin
--

COPY public.__diesel_schema_migrations (version, run_on) FROM stdin;
00000000000000	2024-08-29 11:55:07.714032
20240413204151	2024-09-23 10:28:41.951603
\.


--
-- Data for Name: issues; Type: TABLE DATA; Schema: public; Owner: kudosadmin
--

COPY public.issues (id, number, title, labels, open, certified, assignee_id, repository_id, issue_created_at, issue_closed_at, created_at, updated_at) FROM stdin;
142	5643	`CandidateValidationMessage::ValidateFromChainState` isn't used in production	{}	t	f	\N	11	2024-09-09 08:42:46+00	\N	2024-09-25 14:49:58.209927+00	\N
143	5642	Replace chain extension by pre compiles	{}	t	f	\N	11	2024-09-09 07:04:18+00	\N	2024-09-25 14:49:58.209927+00	\N
144	5641	Replace `lazy_static` with `OnceLock`	{D0-easy,C2-good-first-issue}	t	f	\N	11	2024-09-09 06:34:51+00	\N	2024-09-25 14:49:58.209927+00	\N
145	5626	`fatxpool`: cross check (and improve) support for mortal transactions	{T0-node}	t	f	\N	11	2024-09-06 15:17:26+00	\N	2024-09-25 14:49:58.209927+00	\N
146	5624	Block production/forking issues caused by malicious/not synced peers	{}	t	f	\N	11	2024-09-06 13:41:40+00	\N	2024-09-25 14:49:58.209927+00	\N
147	5621	Remove migration framework and use Frame MBM instead	{}	t	f	\N	11	2024-09-06 12:44:14+00	\N	2024-09-25 14:49:58.209927+00	\N
148	5617	Fragment chain test might not use proper candidates list	{I10-unconfirmed}	t	f	\N	11	2024-09-06 10:36:37+00	\N	2024-09-25 14:49:58.209927+00	\N
149	5614	Binary tries for substrate/Towards NOMT	{}	t	f	\N	11	2024-09-06 08:46:38+00	\N	2024-09-25 14:49:58.209927+00	\N
150	5611	Add immutables to contract metadata	{}	t	f	\N	11	2024-09-05 21:07:58+00	\N	2024-09-25 14:49:58.209927+00	\N
151	5605	chainHead: Simplify code around the assumptions of the old pruning logic	{T3-RPC_API}	t	f	\N	11	2024-09-05 12:42:55+00	\N	2024-09-25 14:49:58.209927+00	\N
153	5595	litep2p: Kusama validator crashes repeatedly	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-09-04 18:25:54+00	\N	2024-09-25 14:49:58.209927+00	\N
154	5593	Deploy canary Glutton parachains on Kusama	{T10-tests}	t	f	\N	11	2024-09-04 16:16:47+00	\N	2024-09-25 14:49:58.209927+00	\N
155	5591	Re-consideration `poke` for Deposits 	{T1-FRAME,T2-pallets}	t	f	\N	11	2024-09-04 15:30:03+00	\N	2024-09-25 14:49:58.209927+00	\N
156	5589	JSON-RPC: performance problem with `chainHead_v1_storage` queries using `descendantValues`	{I3-annoyance,T3-RPC_API}	t	f	\N	11	2024-09-04 14:37:51+00	\N	2024-09-25 14:49:58.209927+00	\N
157	5588	D-Day Governance	{T1-FRAME}	t	f	\N	11	2024-09-04 14:26:45+00	\N	2024-09-25 14:49:58.209927+00	\N
158	5587	Parent issue for `stable2412` LTS release	{}	t	f	\N	11	2024-09-04 11:39:32+00	\N	2024-09-25 14:49:58.209927+00	\N
160	5576	Add a mapping where Account32 wallets can register a 20 -> 32 mapping.	{}	t	f	\N	11	2024-09-03 15:03:00+00	\N	2024-09-25 14:49:58.209927+00	\N
161	5570	chain_id can be abused to set a database path outside of base_path	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-09-03 13:25:34+00	\N	2024-09-25 14:49:58.209927+00	\N
162	5569	`polkadot-omni-node`: avoid `frame-*` and `pallet-*` dependencies in `polkadot-parachain-lib`	{}	t	f	\N	11	2024-09-03 13:16:55+00	\N	2024-09-25 14:49:58.209927+00	\N
163	5568	`polkadot-omni-node` Meta: Tutorials and reference docs. 	{}	t	f	\N	11	2024-09-03 12:35:14+00	\N	2024-09-25 14:49:58.209927+00	\N
164	5567	`polkadot-omni-node`: Merge (back) `bencher`, `chain-spec` (and even `try-runtime`)	{}	t	f	\N	11	2024-09-03 12:29:29+00	\N	2024-09-25 14:49:58.209927+00	\N
165	5566	`polkadot-omni-node`: re-namings	{}	t	f	\N	11	2024-09-03 12:23:42+00	\N	2024-09-25 14:49:58.209927+00	\N
166	5565	`polkadot-omni-node`: Metadata checks 	{}	t	f	\N	11	2024-09-03 12:14:28+00	\N	2024-09-25 14:49:58.209927+00	\N
167	5564	`polkadot-omni-node`: Fully remove `benchmark` sub-command	{}	t	f	\N	11	2024-09-03 12:12:10+00	\N	2024-09-25 14:49:58.209927+00	\N
168	5562	We now depend on native openssl again	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-09-03 11:40:49+00	\N	2024-09-25 14:49:58.209927+00	\N
169	5559	Allow to start Substrate service without RPC server	{I5-enhancement}	t	f	\N	11	2024-09-03 07:00:32+00	\N	2024-09-25 14:49:58.209927+00	\N
170	5552	Bridge Permissionless Lanes - more tests	{T10-tests,T15-bridges}	t	f	\N	11	2024-09-02 15:26:16+00	\N	2024-09-25 14:49:58.209927+00	\N
171	5551	Add `LocalXcmChannelManager` impls for XcmpQueue and BridgeHubs	{}	t	f	\N	11	2024-09-02 14:38:19+00	\N	2024-09-25 14:49:58.209927+00	\N
172	5550	Add benchmarks for `pallet-xcm-bridge-hub`	{}	t	f	\N	11	2024-09-02 14:30:09+00	\N	2024-09-25 14:49:58.209927+00	\N
173	5544	Increase para block inclusion reliability	{}	t	f	\N	11	2024-09-02 08:06:39+00	\N	2024-09-25 14:49:58.209927+00	\N
175	5530	PVF: drop backing jobs if it is too late	{I9-optimisation}	t	f	\N	11	2024-08-30 10:03:01+00	\N	2024-09-25 14:49:58.209927+00	\N
176	5529	runtime refactoring: remove the claim queue from the scheduler	{I4-refactor,T4-runtime_API,T8-polkadot}	t	f	\N	11	2024-08-29 17:38:04+00	\N	2024-09-25 14:49:58.209927+00	\N
177	5520	Refactor `paras_inherent::Pallet::enter`	{I4-refactor,T8-polkadot}	t	f	\N	11	2024-08-29 12:21:43+00	\N	2024-09-25 14:49:58.209927+00	\N
178	5508	rpc server: tracking/stabilize `--experimental-rpc-endpoint` CLI 	{}	t	f	\N	11	2024-08-28 08:54:49+00	\N	2024-09-25 14:49:58.209927+00	\N
174	5532	`sp_genesis_builder::PresetId`: improvement	{}	t	f	\N	11	2024-08-30 12:59:08+00	\N	2024-09-25 14:49:58.209927+00	\N
159	5583	Parent issue for `stable2409` LTS release	{}	t	f	\N	11	2024-09-04 09:41:12+00	\N	2024-09-25 14:49:58.209927+00	\N
152	5596	Unexpected behaviour of block `import_notification_stream`	{I2-bug,I10-unconfirmed}	f	f	\N	11	2024-09-05 02:19:51+00	2024-09-28 16:43:39+00	2024-09-25 14:49:58.209927+00	\N
107	5827	Investigation of deploying `pallet-bridge-messages` directly on the source/destination chain	{T15-bridges}	t	f	\N	11	2024-09-25 07:32:20+00	\N	2024-09-25 14:49:58.209927+00	\N
108	5818	Make subsystems more robust on runtime-apis calls taking long time/hanging	{}	t	f	\N	11	2024-09-24 11:18:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1588	103	List approved Wish for Change Technical proposals (OpenGov) on Kudos	{kudos}	t	t	\N	14	2024-07-08 10:15:35+00	\N	2024-09-25 14:52:57.517867+00	\N
1589	98	Add job to find "tip" commands	{}	t	f	\N	14	2024-03-06 00:53:02+00	\N	2024-09-25 14:52:57.517867+00	\N
1590	97	Add backend to support tipping system	{enhancement}	t	f	\N	14	2024-03-06 00:52:23+00	\N	2024-09-25 14:52:57.517867+00	\N
1591	92	Tracking issue for tipping page	{}	t	f	\N	14	2024-03-01 18:08:31+00	\N	2024-09-25 14:52:57.517867+00	\N
1592	91	Tracking Issue for Kudos Specific Labels Integration	{kudos-milestone}	t	f	\N	14	2024-02-29 13:30:42+00	\N	2024-09-25 14:52:57.517867+00	\N
1593	90	Create "Projects" page	{}	t	f	\N	14	2024-02-23 19:24:17+00	\N	2024-09-25 14:52:57.517867+00	\N
1594	89	Create "Project" page	{}	t	f	\N	14	2024-02-23 19:04:36+00	\N	2024-09-25 14:52:57.517867+00	\N
1595	88	Enhanced "Interest" browsing	{kudos}	t	t	\N	14	2024-02-23 18:56:28+00	\N	2024-09-25 14:52:57.517867+00	\N
1596	87	Implement "Kudos Milestone" label	{kudos}	t	t	\N	14	2024-02-23 18:37:21+00	\N	2024-09-25 14:52:57.517867+00	\N
1597	82	Implement "Kudos Issue" label	{kudos}	t	t	\N	14	2024-02-17 16:22:47+00	\N	2024-09-25 14:52:57.517867+00	\N
1598	75	Make each issue shareable on socials with proper Metadata and OG image generation	{}	t	f	\N	14	2024-02-08 18:32:28+00	\N	2024-09-25 14:52:57.517867+00	\N
1599	74	[HOMEPAGE] FAQ Section	{}	t	f	\N	14	2024-02-08 18:17:52+00	\N	2024-09-25 14:52:57.517867+00	\N
1600	70	[HOMEPAGE] Trending Interest Section	{}	t	f	\N	14	2024-02-08 18:11:53+00	\N	2024-09-25 14:52:57.517867+00	\N
1601	69	[HOMEPAGE] Top Teams Section	{}	t	f	\N	14	2024-02-08 18:10:53+00	\N	2024-09-25 14:52:57.517867+00	\N
1602	64	Protect us against offensive issues	{}	t	f	\N	14	2024-02-08 17:04:16+00	\N	2024-09-25 14:52:57.517867+00	\N
1603	55	Improvements to fix PageSpeed insights	{}	t	f	\N	14	2024-02-07 18:22:34+00	\N	2024-09-25 14:52:57.517867+00	\N
1604	50	Associate a difficulty to issues	{}	t	f	\N	14	2024-02-05 22:41:57+00	\N	2024-09-25 14:52:57.517867+00	\N
1605	49	Display issue status	{}	t	f	\N	14	2024-02-05 22:41:08+00	\N	2024-09-25 14:52:57.517867+00	\N
1606	48	Show more projects in the home screen	{enhancement}	t	f	\N	14	2024-02-05 12:56:08+00	\N	2024-09-25 14:52:57.517867+00	\N
1607	27	Data sanitation 	{enhancement}	t	f	\N	14	2024-01-11 17:58:32+00	\N	2024-09-25 14:52:57.517867+00	\N
109	5817	E2E test for runtime upgrades	{}	t	f	\N	11	2024-09-24 11:06:29+00	\N	2024-09-25 14:49:58.209927+00	\N
110	5816	approval-voting-parallel subsystem production enablement	{T8-polkadot}	t	f	\N	11	2024-09-24 10:35:30+00	\N	2024-09-25 14:49:58.209927+00	\N
112	5809	`fatxpool`: cross check (and improve) support for priority transactions	{T0-node}	t	f	\N	11	2024-09-23 12:56:17+00	\N	2024-09-25 14:49:58.209927+00	\N
113	5793	Fix `allow(dead_code)` in polkadot-overseer	{}	t	f	\N	11	2024-09-20 22:15:49+00	\N	2024-09-25 14:49:58.209927+00	\N
114	5792	Ensure weights are correct	{}	t	f	\N	11	2024-09-20 17:08:41+00	\N	2024-09-25 14:49:58.209927+00	\N
115	5791	[Staking] Extra check for Virtual Stakers	{I9-optimisation,T2-pallets}	t	f	\N	11	2024-09-20 16:57:42+00	\N	2024-09-25 14:49:58.209927+00	\N
116	5790	Add `GenesisConfig` presets for templates runtimes (minimal and solochain)	{}	t	f	\N	11	2024-09-20 16:19:52+00	\N	2024-09-25 14:49:58.209927+00	\N
117	5788	`EthereumBlobExporter` should not consume `dest/msg` when returning `NotApplicable`	{C1-mentor,T15-bridges,C2-good-first-issue}	t	f	\N	11	2024-09-20 08:19:37+00	\N	2024-09-25 14:49:58.209927+00	\N
118	5781	Unable to register parathread despite having sufficient transferable balance	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-09-19 21:04:49+00	\N	2024-09-25 14:49:58.209927+00	\N
119	5778	Kusama Slash Era 7126 - What went wrong?	{}	t	f	\N	11	2024-09-19 20:08:29+00	\N	2024-09-25 14:49:58.209927+00	\N
120	5777	Consider removing useless `-sign-ext` flag in substrate-wasm-builder 	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-09-19 18:12:18+00	\N	2024-09-25 14:49:58.209927+00	\N
121	5775	Multiblock Staking: Add core tests	{T2-pallets}	t	f	\N	11	2024-09-19 14:20:42+00	\N	2024-09-25 14:49:58.209927+00	\N
122	5761	JSON-RPC: `chainHead_v1_follow` Subscription Sends `newBlock` events with unannounced `parentBlockHash`	{I10-unconfirmed}	t	f	\N	11	2024-09-18 23:10:58+00	\N	2024-09-25 14:49:58.209927+00	\N
123	5754	Collation fetching fairness - handle group rotations	{I3-annoyance,T8-polkadot}	t	f	\N	11	2024-09-18 12:05:02+00	\N	2024-09-25 14:49:58.209927+00	\N
124	5750	Integrate revive into westend runtime	{}	t	f	\N	11	2024-09-18 06:47:31+00	\N	2024-09-25 14:49:58.209927+00	\N
125	5749	Merge RPC translation layer into polkadot-sdk	{}	t	f	\N	11	2024-09-18 06:47:26+00	\N	2024-09-25 14:49:58.209927+00	\N
126	5746	[pallet_asset_conversion] Example for integrating pallet asset conversion on a solochain.	{T11-documentation}	t	f	\N	11	2024-09-18 02:48:44+00	\N	2024-09-25 14:49:58.209927+00	\N
127	5744	Can't run the node after updating to polkadot-v1.8.0	{}	t	f	\N	11	2024-09-17 19:47:54+00	\N	2024-09-25 14:49:58.209927+00	\N
128	5742	Ensure nomination pool members can directly stake and vice versa.	{T2-pallets,T8-polkadot,D0-easy}	t	f	\N	11	2024-09-17 16:00:54+00	\N	2024-09-25 14:49:58.209927+00	\N
129	5725	Limit the amount of memory a contract can use	{}	t	f	\N	11	2024-09-16 13:15:04+00	\N	2024-09-25 14:49:58.209927+00	\N
130	5709	Bridges testing improvements	{}	t	f	\N	11	2024-09-13 13:24:37+00	\N	2024-09-25 14:49:58.209927+00	\N
131	5708	`dry_run_xcm` support for BridgeHubs	{T15-bridges}	t	f	\N	11	2024-09-13 13:20:12+00	\N	2024-09-25 14:49:58.209927+00	\N
132	5705	Refactor `get_account_id_from_seed` / `get_from_seed` to one common place	{C1-mentor,C2-good-first-issue}	t	f	\N	11	2024-09-13 11:25:38+00	\N	2024-09-25 14:49:58.209927+00	\N
133	5704	Refactor `polkadot-parachain-bin` chain-specs for cumulus runtimes and move genesis presets to the runtimes `get_preset`	{C1-mentor,T9-cumulus,C2-good-first-issue}	t	f	\N	11	2024-09-13 11:12:08+00	\N	2024-09-25 14:49:58.209927+00	\N
135	5700	Only customized fields in preset json blob?	{}	t	f	\N	11	2024-09-13 07:00:52+00	\N	2024-09-25 14:49:58.209927+00	\N
136	5697	Cargo Clippy Triggers Warning from `#[pallet::call]`	{}	t	f	\N	11	2024-09-12 18:55:51+00	\N	2024-09-25 14:49:58.209927+00	\N
137	5694	Clean up genesis initialization in benchmarking-cli	{I2-bug}	t	f	\N	11	2024-09-12 15:59:43+00	\N	2024-09-25 14:49:58.209927+00	\N
138	5674	Staking Elections: Consider removing validators with no points	{}	t	f	\N	11	2024-09-11 09:32:00+00	\N	2024-09-25 14:49:58.209927+00	\N
139	5668	Strongly type the returned unspent weight in `TransactionExtension`	{}	t	f	\N	11	2024-09-10 16:36:53+00	\N	2024-09-25 14:49:58.209927+00	\N
140	5646	[CI] Make SemVer check backport aware	{}	t	f	\N	11	2024-09-09 10:17:04+00	\N	2024-09-25 14:49:58.209927+00	\N
141	5645	net/litep2p fail to send request ChannelClogged 	{}	t	f	\N	11	2024-09-09 10:07:30+00	\N	2024-09-25 14:49:58.209927+00	\N
111	5812	Fix `cargo-hfuzz` CI job	{}	t	f	\N	11	2024-09-24 08:54:36+00	\N	2024-09-25 14:49:58.209927+00	\N
179	5505	candidate-validation: Request executor params for the next session for PVF precompilation	{T0-node,T8-polkadot}	t	f	\N	11	2024-08-27 15:13:06+00	\N	2024-09-25 14:49:58.209927+00	\N
180	5500	Iterating Treasury and Bounty Pallets: Proposed Updates	{}	t	f	\N	11	2024-08-27 11:44:42+00	\N	2024-09-25 14:49:58.209927+00	\N
181	5497	`fatxpool`: add heavy load testsuits	{T0-node}	t	f	\N	11	2024-08-27 07:05:34+00	\N	2024-09-25 14:49:58.209927+00	\N
182	5496	`fatxpool`: view revalidation shall revalidate futures transactions	{T0-node}	t	f	\N	11	2024-08-27 07:05:33+00	\N	2024-09-25 14:49:58.209927+00	\N
183	5495	`fatxpool`: improve event listeners	{T0-node}	t	f	\N	11	2024-08-27 07:05:32+00	\N	2024-09-25 14:49:58.209927+00	\N
185	5493	`fatxpool`: implement `LocalTransactionPool`	{T0-node}	t	f	\N	11	2024-08-27 07:05:30+00	\N	2024-09-25 14:49:58.209927+00	\N
186	5492	`fatxpool`: improve handle finalization	{T0-node}	t	f	\N	11	2024-08-27 07:05:29+00	\N	2024-09-25 14:49:58.209927+00	\N
187	5491	`fatxpool`: API considerations	{T0-node}	t	f	\N	11	2024-08-27 07:03:24+00	\N	2024-09-25 14:49:58.209927+00	\N
188	5490	`fatxpool`: use `tracing` instead of `log`	{T0-node}	t	f	\N	11	2024-08-27 07:03:23+00	\N	2024-09-25 14:49:58.209927+00	\N
189	5489	`fatxpool`: use `dyn` instead of `TransactionPoolWrapper`	{T0-node}	t	f	\N	11	2024-08-27 07:03:22+00	\N	2024-09-25 14:49:58.209927+00	\N
191	5487	`fatxpool`: peer is sometimes not reconnecting after multiple `clogged` issue	{T0-node}	t	f	\N	11	2024-08-27 07:03:21+00	\N	2024-09-25 14:49:58.209927+00	\N
192	5486	`fatxpool`: networking::transaction subsystem `clogged` issue with many transactions	{T0-node}	t	f	\N	11	2024-08-27 07:03:20+00	\N	2024-09-25 14:49:58.209927+00	\N
193	5485	`fatxpool`: use `fatxpool` in tests of other components	{T0-node}	t	f	\N	11	2024-08-27 07:03:19+00	\N	2024-09-25 14:49:58.209927+00	\N
194	5484	`fatxpool`: prepare zombienet scenarios for CI	{T0-node}	t	f	\N	11	2024-08-27 07:03:18+00	\N	2024-09-25 14:49:58.209927+00	\N
195	5483	`fatxpool`: cross check (and improve) warp-sync scenarios	{T0-node}	t	f	\N	11	2024-08-27 07:03:17+00	\N	2024-09-25 14:49:58.209927+00	\N
196	5482	`fatxpool`: check (and improve) behaviour for finality stalls	{T0-node}	t	f	\N	11	2024-08-27 07:03:16+00	\N	2024-09-25 14:49:58.209927+00	\N
197	5481	`fatxpool`: add tests for mempool revalidation	{T0-node}	t	f	\N	11	2024-08-27 07:03:15+00	\N	2024-09-25 14:49:58.209927+00	\N
198	5480	`fatxpool`: add tests for view revalidation	{T0-node}	t	f	\N	11	2024-08-27 07:03:14+00	\N	2024-09-25 14:49:58.209927+00	\N
199	5479	`fatxpool`: add retracted event	{T0-node}	t	f	\N	11	2024-08-27 07:03:13+00	\N	2024-09-25 14:49:58.209927+00	\N
200	5478	`fatxpool`: add tests for limits	{T0-node}	t	f	\N	11	2024-08-27 07:03:12+00	\N	2024-09-25 14:49:58.209927+00	\N
201	5477	`fatxpool`: add tests for rejecting invalid transactions	{T0-node}	t	f	\N	11	2024-08-27 07:03:12+00	\N	2024-09-25 14:49:58.209927+00	\N
202	5476	`fatxpool`: size limits shall be obeyed	{T0-node}	t	f	\N	11	2024-08-27 07:03:11+00	\N	2024-09-25 14:49:58.209927+00	\N
203	5474	`fatxpool`: add LRUCache for views.	{T0-node}	t	f	\N	11	2024-08-27 07:03:09+00	\N	2024-09-25 14:49:58.209927+00	\N
204	5472	`fatxpool`: Master issue for upcoming work	{T0-node}	t	f	\N	11	2024-08-27 07:03:07+00	\N	2024-09-25 14:49:58.209927+00	\N
205	5458	Issues with Unresolved Types in `runtime/src/lib.rs` While Working with Substrate	{I10-unconfirmed}	t	f	\N	11	2024-08-25 09:35:52+00	\N	2024-09-25 14:49:58.209927+00	\N
206	5452	Revert to latest finalized doesn't work	{I2-bug}	t	f	\N	11	2024-08-23 14:51:36+00	\N	2024-09-25 14:49:58.209927+00	\N
207	5451	sync: Remove periodic tick from `SyncingEngine`	{I3-annoyance,D1-medium}	t	f	\N	11	2024-08-23 14:07:56+00	\N	2024-09-25 14:49:58.209927+00	\N
208	5444	Backports	{}	t	f	\N	11	2024-08-23 09:36:55+00	\N	2024-09-25 14:49:58.209927+00	\N
209	5433	[Help] Mapping XCM Extrinsics Between Polkadot and Asset Hub	{I10-unconfirmed}	t	f	\N	11	2024-08-21 13:05:24+00	\N	2024-09-25 14:49:58.209927+00	\N
210	5432	subsystem-benchmarks: estimate reference hardware CPU usage	{T10-tests,T12-benchmarks}	t	f	\N	11	2024-08-21 09:49:49+00	\N	2024-09-25 14:49:58.209927+00	\N
211	5426	Collator protocol: connect only to backing group of selected core	{}	t	f	\N	11	2024-08-20 16:46:07+00	\N	2024-09-25 14:49:58.209927+00	\N
212	5419	chain-spec building failure due to WASM allocation size	{T0-node}	t	f	\N	11	2024-08-20 14:06:44+00	\N	2024-09-25 14:49:58.209927+00	\N
213	5415	Investigate why `grandpa`  is sending the most message out of all protocols	{}	t	f	\N	11	2024-08-20 11:34:16+00	\N	2024-09-25 14:49:58.209927+00	\N
214	5414	network/sync: Extra justification response might be lost when peer disconnects	{T0-node,I2-bug,D0-easy}	t	f	\N	11	2024-08-20 10:29:04+00	\N	2024-09-25 14:49:58.209927+00	\N
215	5406	Why request block body for fast sync?	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-08-19 07:48:46+00	\N	2024-09-25 14:49:58.209927+00	\N
216	5403	release polkadot-parachain-bin	{}	t	f	\N	11	2024-08-19 03:05:44+00	\N	2024-09-25 14:49:58.209927+00	\N
217	5397	Improve the state sync progress report	{I5-enhancement}	t	f	\N	11	2024-08-18 14:31:13+00	\N	2024-09-25 14:49:58.209927+00	\N
218	5383	Database corruption during warp sync	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-08-16 12:32:52+00	\N	2024-09-25 14:49:58.209927+00	\N
219	5379	Node sends 1k "Duplicate gossip" msgs	{T0-node,I2-bug}	t	f	\N	11	2024-08-16 06:31:10+00	\N	2024-09-25 14:49:58.209927+00	\N
220	5368	[NPos] Expose `pallet-delegated-staking` via extrinsics	{I5-enhancement}	t	f	\N	11	2024-08-14 19:44:36+00	\N	2024-09-25 14:49:58.209927+00	\N
221	5366	Make Warp/Light sync and custom sync protocols work by design rather than by accident	{I5-enhancement}	t	f	\N	11	2024-08-14 15:25:44+00	\N	2024-09-25 14:49:58.209927+00	\N
222	5357	Remove ElasticScalingMVP support	{}	t	f	\N	11	2024-08-14 09:50:24+00	\N	2024-09-25 14:49:58.209927+00	\N
223	5353	Fix benchmark failure in pallet-membership when it's used on its own	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-08-14 02:41:48+00	\N	2024-09-25 14:49:58.209927+00	\N
224	5347	Fix metadata naming around migration from `SignedExtension` to `TransactionExtension`	{}	t	f	\N	11	2024-08-13 16:55:49+00	\N	2024-09-25 14:49:58.209927+00	\N
225	5335	Consider adding rust-toolchain.toml to the repo	{}	t	f	\N	11	2024-08-13 08:27:33+00	\N	2024-09-25 14:49:58.209927+00	\N
227	5333	Make `SyncingStrategy` abstract and allow developers to customize it	{I5-enhancement}	t	f	\N	11	2024-08-13 08:00:35+00	\N	2024-09-25 14:49:58.209927+00	\N
228	5320	pallet_section not work for storage	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-08-12 11:46:54+00	\N	2024-09-25 14:49:58.209927+00	\N
229	5313	Extrinsic accepted by the node but not included into the block	{I10-unconfirmed}	t	f	\N	11	2024-08-11 06:18:57+00	\N	2024-09-25 14:49:58.209927+00	\N
230	5312	Compress the state response to reduce the state sync data transfer	{I5-enhancement}	t	f	\N	11	2024-08-11 03:50:49+00	\N	2024-09-25 14:49:58.209927+00	\N
190	5488	`fatxpool`: add test for `ready_at_with_timeout`	{T0-node}	f	f	167	11	2024-08-27 07:03:22+00	2024-09-27 07:29:49+00	2024-09-25 14:49:58.209927+00	\N
231	5309	bdalhafzslah382@gmail.com \nAbdulhafez \n0xFD689e5f2d8d9Aec0aD328225Ae62FdBDdb30328	{}	t	f	\N	11	2024-08-09 16:55:45+00	\N	2024-09-25 14:49:58.209927+00	\N
232	5308	`pallet_revive` launch tracking issue	{}	t	f	\N	11	2024-08-09 16:47:57+00	\N	2024-09-25 14:49:58.209927+00	\N
233	5303	Add `benchmark overhead` to `frame-omni-bencher`	{}	t	f	\N	11	2024-08-09 13:25:56+00	\N	2024-09-25 14:49:58.209927+00	\N
234	5298	`pallet-assets` sufficient assets ED should provide same benefits as DOT ED	{T1-FRAME,T2-pallets}	t	f	\N	11	2024-08-09 08:29:09+00	\N	2024-09-25 14:49:58.209927+00	\N
235	5286	Incorrect message for xcm::v4::Assets decoding error	{}	t	f	\N	11	2024-08-08 14:18:59+00	\N	2024-09-25 14:49:58.209927+00	\N
236	5285	Metadata V16: Return multiple signed extensions by version	{I5-enhancement,T1-FRAME}	t	f	\N	11	2024-08-08 11:36:40+00	\N	2024-09-25 14:49:58.209927+00	\N
237	5271	Chain-spec Builder ignores SS58 prefix for invulnerables/session keys when generating chain-specs	{T0-node}	t	f	\N	11	2024-08-07 09:50:48+00	\N	2024-09-25 14:49:58.209927+00	\N
239	5265	Upgrading bootnode client code from polkadot-v0.9.38 to polkadot-v1.1.0 causes bans	{I10-unconfirmed}	t	f	\N	11	2024-08-06 15:30:27+00	\N	2024-09-25 14:49:58.209927+00	\N
240	5263	Startup script: Use the CI rust version of polkadot-sdk	{D0-easy}	t	f	\N	11	2024-08-06 13:32:37+00	\N	2024-09-25 14:49:58.209927+00	\N
241	5260	slot-based collator needs higher than expected unincluded segment size	{I2-bug,T9-cumulus}	t	f	\N	11	2024-08-06 13:10:23+00	\N	2024-09-25 14:49:58.209927+00	\N
242	5242	Make `polkadot-sdk` templates OMNI and GREAT again -- part 2	{C1-mentor,I6-meta,C2-good-first-issue}	t	f	\N	11	2024-08-05 12:39:36+00	\N	2024-09-25 14:49:58.209927+00	\N
243	5241	[XCM]: Remove NetworkIds for testnets	{}	t	f	\N	11	2024-08-05 12:33:35+00	\N	2024-09-25 14:49:58.209927+00	\N
244	5239	network/litep2p: High number of connection errors during handshake	{}	t	f	\N	11	2024-08-05 10:33:14+00	\N	2024-09-25 14:49:58.209927+00	\N
245	5238	Add zombienet warp sync test including a beefy `ConsensusReset`	{}	t	f	\N	11	2024-08-05 09:53:24+00	\N	2024-09-25 14:49:58.209927+00	\N
246	5236	network: Investigate sudden sync peer count drops	{}	t	f	\N	11	2024-08-05 09:41:40+00	\N	2024-09-25 14:49:58.209927+00	\N
247	5229	PoV reclaim underestimates proof size	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-08-04 09:25:35+00	\N	2024-09-25 14:49:58.209927+00	\N
248	5224	Fix CandidateHash newtype	{C2-good-first-issue}	t	f	\N	11	2024-08-03 05:13:04+00	\N	2024-09-25 14:49:58.209927+00	\N
249	5223	FRAME: why not refund the weight used for storage access accurately with a new `DataBaseAccessExt`	{T1-FRAME}	t	f	\N	11	2024-08-02 23:47:46+00	\N	2024-09-25 14:49:58.209927+00	\N
250	5221	network/libp2p: worker CPU usage increases from v1.13.0 to v1.15.0	{}	t	f	\N	11	2024-08-02 12:29:14+00	\N	2024-09-25 14:49:58.209927+00	\N
252	5209	Implement new XCM `InitiateAssetsTransfer` instruction	{}	t	f	\N	11	2024-08-01 17:10:10+00	\N	2024-09-25 14:49:58.209927+00	\N
253	5208	Implement new XCM fees handling mechanism in a backwards compatible way	{}	t	f	\N	11	2024-08-01 17:08:42+00	\N	2024-09-25 14:49:58.209927+00	\N
254	5207	XCM Cookbook: more recipes	{T11-documentation}	t	f	\N	11	2024-08-01 16:41:55+00	\N	2024-09-25 14:49:58.209927+00	\N
255	5192	Idea: polkadot-dev CLI	{C1-mentor,D1-medium,C2-good-first-issue}	t	f	\N	11	2024-07-30 18:22:09+00	\N	2024-09-25 14:49:58.209927+00	\N
256	5190	Elastic Scaling: Streamlined Block Production	{}	t	f	\N	11	2024-07-30 15:17:47+00	\N	2024-09-25 14:49:58.209927+00	\N
257	5185	pallet macro: Tasks doesn't support instantiable pallets.	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-07-30 11:20:12+00	\N	2024-09-25 14:49:58.209927+00	\N
258	5160	Allow payment of local delivery fees in other assets	{}	t	f	\N	11	2024-07-26 20:43:56+00	\N	2024-09-25 14:49:58.209927+00	\N
259	5144	[CI] Check for getting-started script	{}	t	f	\N	11	2024-07-25 14:13:17+00	\N	2024-09-25 14:49:58.209927+00	\N
260	5119	Gap Synced blocks are kept even though they are out of pruning window	{}	t	f	\N	11	2024-07-23 15:09:43+00	\N	2024-09-25 14:49:58.209927+00	\N
261	5102	Fix `docify` integration with RA	{}	t	f	\N	11	2024-07-22 09:24:36+00	\N	2024-09-25 14:49:58.209927+00	\N
262	5101	Allow to trigger `try-runtime` and `runtime-benchmarks` by only enabling it on one crate: sp-runtime	{I5-enhancement}	t	f	\N	11	2024-07-22 08:00:01+00	\N	2024-09-25 14:49:58.209927+00	\N
263	5079	Deprecate and remove `AsyncBackingParameters`	{}	t	f	\N	11	2024-07-19 13:26:38+00	\N	2024-09-25 14:49:58.209927+00	\N
264	5053	Using warp sync on parachain triggers OOM	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-07-17 15:28:05+00	\N	2024-09-25 14:49:58.209927+00	\N
265	5051	Elastic scaling: core index commitments deployment	{}	t	f	\N	11	2024-07-17 09:23:13+00	\N	2024-09-25 14:49:58.209927+00	\N
266	5050	Elastic scaling: adjust the implementers guide documentation	{}	t	f	\N	11	2024-07-17 09:22:43+00	\N	2024-09-25 14:49:58.209927+00	\N
267	5049	Elastic scaling: zombienet tests	{}	t	f	\N	11	2024-07-17 09:22:35+00	\N	2024-09-25 14:49:58.209927+00	\N
268	5048	Elastic scaling: cumulus node + parachain system changes	{}	t	f	\N	11	2024-07-17 09:22:29+00	\N	2024-09-25 14:49:58.209927+00	\N
269	5047	Elastic scaling: polkadot node support for new candidate receipts	{}	t	f	\N	11	2024-07-17 09:22:22+00	\N	2024-09-25 14:49:58.209927+00	\N
270	5046	Elastic scaling: UMP transport changes	{}	t	f	\N	11	2024-07-17 09:22:15+00	\N	2024-09-25 14:49:58.209927+00	\N
271	5045	Elastic scaling: relay chain support for new candidate receipts	{}	t	f	\N	11	2024-07-17 09:22:09+00	\N	2024-09-25 14:49:58.209927+00	\N
272	5035	Subsystem benchmarks: determine node CPU usage for 1000 validators and 200 full occupied cores	{T10-tests}	t	f	\N	11	2024-07-16 15:36:01+00	\N	2024-09-25 14:49:58.209927+00	\N
273	5034	Network Stalls Post-Parachain Connection on Polkadot v1.0.0 with BEEFY enabled	{I10-unconfirmed}	t	f	\N	11	2024-07-16 14:16:12+00	\N	2024-09-25 14:49:58.209927+00	\N
274	5033	Bounty Pallet Overhaul	{C1-mentor,T2-pallets}	t	f	\N	11	2024-07-16 13:16:35+00	\N	2024-09-25 14:49:58.209927+00	\N
275	5030	approval-distribution/approval-voting:  Mismatch in cleaning unneeded blocks	{I3-annoyance}	t	f	\N	11	2024-07-16 11:35:05+00	\N	2024-09-25 14:49:58.209927+00	\N
276	5026	Omni-node: add support for starting a dev chain with manual seal	{T0-node}	t	f	\N	11	2024-07-16 10:21:15+00	\N	2024-09-25 14:49:58.209927+00	\N
277	5025	On AllExtrinsicsLen and ExtrinsicCount being killed on_finalize	{}	t	f	\N	11	2024-07-16 09:56:07+00	\N	2024-09-25 14:49:58.209927+00	\N
278	5024	network: Move number of connected peers metric to the sync component	{I4-refactor,D0-easy}	t	f	\N	11	2024-07-16 08:40:48+00	\N	2024-09-25 14:49:58.209927+00	\N
279	5019	network/litep2p: Validators do not seem to be fully connected when using litep2p backend	{}	t	f	\N	11	2024-07-15 13:49:19+00	\N	2024-09-25 14:49:58.209927+00	\N
280	5012	Reduce storage deposit for parachain PVFs	{}	t	f	\N	11	2024-07-13 16:10:23+00	\N	2024-09-25 14:49:58.209927+00	\N
334	4681	litep2p: Introduce metrics to reflect libp2p metrics	{}	t	f	\N	11	2024-06-03 13:54:32+00	\N	2024-09-25 14:49:58.209927+00	\N
238	5266	network: Require validators to provide CLI param `--public-addresses` for starting nodes	{}	t	f	\N	11	2024-08-06 16:23:35+00	\N	2024-09-25 14:49:58.209927+00	\N
282	5004	Remove `HasCompact` from `BaseArithmetic`	{I10-unconfirmed}	t	f	\N	11	2024-07-11 12:26:12+00	\N	2024-09-25 14:49:58.209927+00	\N
283	4995	Remove jaeger	{T0-node,I9-optimisation,C1-mentor,T8-polkadot,C2-good-first-issue}	t	f	\N	11	2024-07-10 15:23:35+00	\N	2024-09-25 14:49:58.209927+00	\N
284	4991	Paravalidators authoring blocks but missing all votes	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-07-10 06:12:21+00	\N	2024-09-25 14:49:58.209927+00	\N
285	4988	List of supported XCM assets Runtime API	{}	t	f	\N	11	2024-07-09 13:52:46+00	\N	2024-09-25 14:49:58.209927+00	\N
286	4985	network/litep2p: Investigate beefy ran out of peers to request justif	{}	t	f	\N	11	2024-07-09 11:54:52+00	\N	2024-09-25 14:49:58.209927+00	\N
287	4984	network: Investigate importing block with unknown parent	{}	t	f	\N	11	2024-07-09 11:41:09+00	\N	2024-09-25 14:49:58.209927+00	\N
288	4979	Deprecation tracking issue for `XcmFeeToAccount`	{I10-unconfirmed}	t	f	\N	11	2024-07-09 06:20:05+00	\N	2024-09-25 14:49:58.209927+00	\N
289	4947	Remove sequential increment requirements for Child Bounties	{I5-enhancement}	t	f	\N	11	2024-07-04 15:54:24+00	\N	2024-09-25 14:49:58.209927+00	\N
290	4939	Panic at Option::unwrap() on a None value in parity-db during Cloud Migration with Polkadot v1.12.0	{I10-unconfirmed}	t	f	\N	11	2024-07-04 08:28:00+00	\N	2024-09-25 14:49:58.209927+00	\N
291	4927	network: Investigate high memory consumption for long-running node	{}	t	f	\N	11	2024-07-02 11:55:56+00	\N	2024-09-25 14:49:58.209927+00	\N
292	4925	network/litep2p: Investigate low peer count for long-running node	{}	t	f	\N	11	2024-07-02 11:41:39+00	\N	2024-09-25 14:49:58.209927+00	\N
293	4924	Banned node for "Same state requested multiple times"	{}	t	f	\N	11	2024-07-02 09:58:59+00	\N	2024-09-25 14:49:58.209927+00	\N
294	4923	Incorrect Block Author Reward During Era Transition in Polkadot and Other Chains	{I2-bug,C2-good-first-issue}	t	f	\N	11	2024-07-02 05:46:08+00	\N	2024-09-25 14:49:58.209927+00	\N
295	4900	Release process: next steps	{}	t	f	\N	11	2024-06-27 13:27:01+00	\N	2024-09-25 14:49:58.209927+00	\N
296	4896	offchain http: upgrade hyper to v1	{I4-refactor}	t	f	\N	11	2024-06-27 09:59:31+00	\N	2024-09-25 14:49:58.209927+00	\N
297	4892	Backport integration tests for claim assets to the `polkadot-sdk` from `polkadot-fellows` repo	{T6-XCM,C1-mentor,C2-good-first-issue}	t	f	\N	11	2024-06-26 22:35:07+00	\N	2024-09-25 14:49:58.209927+00	\N
298	4884	subsystem-benchmarks: test benchmark accuracy 	{T10-tests}	t	f	\N	11	2024-06-26 11:53:09+00	\N	2024-09-25 14:49:58.209927+00	\N
299	4882	Implement additional tests for Coretime revenue	{}	t	f	\N	11	2024-06-26 08:28:55+00	\N	2024-09-25 14:49:58.209927+00	\N
300	4881	Long running tests based on zombienet-sdk	{}	t	f	\N	11	2024-06-26 07:34:14+00	\N	2024-09-25 14:49:58.209927+00	\N
302	4856	Allow removing litep2p from dependencies	{}	t	f	\N	11	2024-06-21 11:54:17+00	\N	2024-09-25 14:49:58.209927+00	\N
303	4854	xcm: support unpaid asset transfers	{T6-XCM}	t	f	\N	11	2024-06-21 10:29:10+00	\N	2024-09-25 14:49:58.209927+00	\N
304	4852	Update non-direct dependencies to curve25519-dalek	{I10-unconfirmed}	t	f	\N	11	2024-06-21 02:01:35+00	\N	2024-09-25 14:49:58.209927+00	\N
305	4843	TransferAllowDeath possibly fails on transaction validation when the balance is around ExistentialDeposit	{I2-bug,I5-enhancement}	t	f	\N	11	2024-06-20 06:38:22+00	\N	2024-09-25 14:49:58.209927+00	\N
306	4841	Too permissive XCM token matching inside tuples	{}	t	f	\N	11	2024-06-20 05:03:27+00	\N	2024-09-25 14:49:58.209927+00	\N
307	4838	Error: Service(Client(Execution(Other("Exported method GrandpaApi_grandpa_authorities is not found"))))	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-06-19 19:11:35+00	\N	2024-09-25 14:49:58.209927+00	\N
308	4832	xcm: multi-hop mixed asset transfers not working because of missing transport fee	{T6-XCM}	t	f	\N	11	2024-06-19 11:37:33+00	\N	2024-09-25 14:49:58.209927+00	\N
309	4827	Custom default configs using `derive_impl`	{T1-FRAME}	t	f	\N	11	2024-06-19 06:19:50+00	\N	2024-09-25 14:49:58.209927+00	\N
310	4817	Release CI: Bulletproof SemVer Checks	{}	t	f	\N	11	2024-06-18 11:54:52+00	\N	2024-09-25 14:49:58.209927+00	\N
311	4815	Minimise boilerplate and repeated code between system parachain runtimes using derive_impl	{}	t	f	\N	11	2024-06-18 11:16:09+00	\N	2024-09-25 14:49:58.209927+00	\N
312	4813	Idea: Block based collator	{}	t	f	\N	11	2024-06-18 09:12:57+00	\N	2024-09-25 14:49:58.209927+00	\N
313	4793	Bridges: enable chopsticks to emulate passing XCM messages over bridge	{T15-bridges}	t	f	\N	11	2024-06-14 06:43:55+00	\N	2024-09-25 14:49:58.209927+00	\N
314	4789	Docker image paritypr/substrate:latest not updated anymore?	{I10-unconfirmed}	t	f	\N	11	2024-06-13 12:05:55+00	\N	2024-09-25 14:49:58.209927+00	\N
315	4787	Investigate `peregrine` syncing issue when using the `polkadot-parachain` binary	{T0-node}	t	f	\N	11	2024-06-13 10:19:27+00	\N	2024-09-25 14:49:58.209927+00	\N
316	4782	Improvements to `polkadot-sdk-frame` umbrella crate	{T1-FRAME,T11-documentation}	t	f	\N	11	2024-06-13 05:18:55+00	\N	2024-09-25 14:49:58.209927+00	\N
317	4781	document the nuances of `DispatchResult`	{T11-documentation}	t	f	\N	11	2024-06-13 04:34:55+00	\N	2024-09-25 14:49:58.209927+00	\N
318	4779	Pallet asset wrong error returns	{}	t	f	\N	11	2024-06-12 18:01:05+00	\N	2024-09-25 14:49:58.209927+00	\N
319	4776	Claim queue: Remove TTL	{}	t	f	\N	11	2024-06-12 15:54:18+00	\N	2024-09-25 14:49:58.209927+00	\N
320	4766	Document the existence of inherinted weights in `#[pallet::call]`	{T1-FRAME,T11-documentation}	t	f	\N	11	2024-06-12 03:57:48+00	\N	2024-09-25 14:49:58.209927+00	\N
321	4762	[MQ pallet] Dont warn for low `on_idle` weight	{C1-mentor,I3-annoyance,C2-good-first-issue}	t	f	\N	11	2024-06-11 13:25:38+00	\N	2024-09-25 14:49:58.209927+00	\N
322	4750	DRAFT: offchain XCMP: Understanding Requirements	{}	t	f	\N	11	2024-06-10 15:40:18+00	\N	2024-09-25 14:49:58.209927+00	\N
323	4746	Enable approval slashes (0%)	{}	t	f	\N	11	2024-06-10 10:42:43+00	\N	2024-09-25 14:49:58.209927+00	\N
324	4745	Track offence severity in the runtime for re-enabling purposes (+ migration)	{}	t	f	\N	11	2024-06-10 10:39:04+00	\N	2024-09-25 14:49:58.209927+00	\N
325	4740	staking.IncorrectSlashingSpans	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-06-08 09:58:49+00	\N	2024-09-25 14:49:58.209927+00	\N
326	4737	offchain XCMP: Merkle tree of para headers in beefy ignores Coretime chains	{}	t	f	\N	11	2024-06-07 14:22:47+00	\N	2024-09-25 14:49:58.209927+00	\N
327	4736	RFC: XCM Asset Transfer Program Builder	{T6-XCM}	t	f	\N	11	2024-06-07 14:07:08+00	\N	2024-09-25 14:49:58.209927+00	\N
328	4725	Remove legacy `CurrencyToVote` in staking	{T2-pallets,D1-medium}	t	f	\N	11	2024-06-07 08:12:32+00	\N	2024-09-25 14:49:58.209927+00	\N
329	4715	RFC: Treasury API for Cross-Chain Transfers	{}	t	f	\N	11	2024-06-05 15:49:15+00	\N	2024-09-25 14:49:58.209927+00	\N
330	4714	Metadata V16: Add code functionality as WASM blob 	{}	t	f	\N	11	2024-06-05 15:19:32+00	\N	2024-09-25 14:49:58.209927+00	\N
331	4708	Full Polkadot Launch Test	{}	t	f	\N	11	2024-06-05 13:00:57+00	\N	2024-09-25 14:49:58.209927+00	\N
332	4707	One elastic chain on Rococo	{}	t	f	\N	11	2024-06-05 12:39:31+00	\N	2024-09-25 14:49:58.209927+00	\N
333	4696	Test how many fully loaded cores we can support with multiple collators	{}	t	f	\N	11	2024-06-04 17:26:58+00	\N	2024-09-25 14:49:58.209927+00	\N
335	4671	Support changing/downgrading state pruning mode	{I5-enhancement}	t	f	\N	11	2024-06-03 09:36:29+00	\N	2024-09-25 14:49:58.209927+00	\N
336	4659	Browser extensions can't sign extrinsics in v1.2.5	{I10-unconfirmed}	t	f	\N	11	2024-05-31 11:50:43+00	\N	2024-09-25 14:49:58.209927+00	\N
337	4657	Long checkouts	{I10-unconfirmed}	t	f	\N	11	2024-05-31 11:27:19+00	\N	2024-09-25 14:49:58.209927+00	\N
338	4652	Add generics on cumulus xcm emulate Chain trait on signature types	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-05-31 00:20:32+00	\N	2024-09-25 14:49:58.209927+00	\N
339	4632	PVF: prioritise execution depending on context	{I9-optimisation,T8-polkadot}	t	f	\N	11	2024-05-29 13:51:02+00	\N	2024-09-25 14:49:58.209927+00	\N
340	4630	[Pools] Build a pool slashing monitoring bot to apply pending slashes to the affected pool members.	{I1-security}	t	f	\N	11	2024-05-29 12:55:04+00	\N	2024-09-25 14:49:58.209927+00	\N
341	4626	Ability to maintain multiple crates with the same/synchronized version	{}	t	f	\N	11	2024-05-29 08:29:22+00	\N	2024-09-25 14:49:58.209927+00	\N
342	4611	subsystem-bench: add emulated network latency for messages and requests coming from local validator	{T8-polkadot,T10-tests}	t	f	\N	11	2024-05-28 07:37:25+00	\N	2024-09-25 14:49:58.209927+00	\N
343	4609	subsystem-bench: add CI regression benches for all av-recovery strategies	{T8-polkadot,T10-tests}	t	f	\N	11	2024-05-28 07:04:52+00	\N	2024-09-25 14:49:58.209927+00	\N
344	4607	Block gap assumes there is a warp sync even when there isn't any	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-05-28 03:29:13+00	\N	2024-09-25 14:49:58.209927+00	\N
345	4602	litep2p update breaks polkadot release v1.11.0	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-05-27 15:42:57+00	\N	2024-09-25 14:49:58.209927+00	\N
346	4591	Client::apply_block() has an awkward API	{}	t	f	\N	11	2024-05-27 05:14:45+00	\N	2024-09-25 14:49:58.209927+00	\N
347	4569	Investigate slow parachains	{I3-annoyance}	t	f	\N	11	2024-05-24 13:09:53+00	\N	2024-09-25 14:49:58.209927+00	\N
348	4565	Para Owner cannot unlock and deregister a Parachain when downgraded to Parathread	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-05-24 10:00:07+00	\N	2024-09-25 14:49:58.209927+00	\N
349	4547	slot-based-collator: improve relay chain fork selection	{I9-optimisation,I2-bug,T9-cumulus}	t	f	\N	11	2024-05-23 07:43:15+00	\N	2024-09-25 14:49:58.209927+00	\N
350	4545	why do we need to do a manual bump in pallet-salary?	{}	t	f	\N	11	2024-05-23 02:06:00+00	\N	2024-09-25 14:49:58.209927+00	\N
351	4526	Add zombienet tests for malicious collators	{T10-tests}	t	f	\N	11	2024-05-20 14:18:57+00	\N	2024-09-25 14:49:58.209927+00	\N
352	4523	Beefy: add runtime support for reporting fork voting	{T15-bridges}	t	f	\N	11	2024-05-20 12:35:19+00	\N	2024-09-25 14:49:58.209927+00	\N
353	4520	Metadata V16: Features to include in V16	{}	t	f	\N	11	2024-05-20 10:52:21+00	\N	2024-09-25 14:49:58.209927+00	\N
354	4519	Metadata V16: Enrich metadata with associated types of config traits	{I5-enhancement,T1-FRAME}	t	f	\N	11	2024-05-20 10:13:25+00	\N	2024-09-25 14:49:58.209927+00	\N
355	4491	revert finalized blocks	{}	t	f	\N	11	2024-05-17 04:32:01+00	\N	2024-09-25 14:49:58.209927+00	\N
356	4469	Research backwards compatible and extensible `CandidateReceipt` format	{}	t	f	\N	11	2024-05-15 12:36:11+00	\N	2024-09-25 14:49:58.209927+00	\N
357	4448	error[E0583]: file not found for module `target_chain`	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-05-13 14:20:38+00	\N	2024-09-25 14:49:58.209927+00	\N
358	4447	Remove non-async backing code from node	{I4-refactor,T8-polkadot}	t	f	\N	11	2024-05-13 13:02:00+00	\N	2024-09-25 14:49:58.209927+00	\N
359	4433	`claim_assets` doesn't work if the trapped asset can't be used to pay for execution fees.	{T6-XCM}	t	f	\N	11	2024-05-10 17:09:35+00	\N	2024-09-25 14:49:58.209927+00	\N
360	4420	rpc: remove rate-limit middleware	{}	t	f	\N	11	2024-05-09 07:43:14+00	\N	2024-09-25 14:49:58.209927+00	\N
361	4419	Staking pallet allows duplicate targets (validators) while nominating	{I10-unconfirmed}	t	f	\N	11	2024-05-08 20:47:15+00	\N	2024-09-25 14:49:58.209927+00	\N
362	4412	[xcm] account reaped at sender despite transactional processing	{T6-XCM}	t	f	\N	11	2024-05-08 12:32:03+00	\N	2024-09-25 14:49:58.209927+00	\N
363	4408	[xcm] Failing to deposit dust (below minimum value) will fail the whole XCM program	{T6-XCM}	t	f	\N	11	2024-05-08 08:20:06+00	\N	2024-09-25 14:49:58.209927+00	\N
364	4397	Investigate report of TI not updating as expected when block reward fee is partially burned	{I10-unconfirmed}	t	f	\N	11	2024-05-07 10:17:14+00	\N	2024-09-25 14:49:58.209927+00	\N
365	4377	[META] XCM Cookbook Asset Guides	{T11-documentation}	t	f	\N	11	2024-05-04 08:09:47+00	\N	2024-09-25 14:49:58.209927+00	\N
366	4359	[Meta] State of Disabling	{}	t	f	\N	11	2024-05-02 13:07:00+00	\N	2024-09-25 14:49:58.209927+00	\N
367	4356	Add a rep cost to unexpected requests in statement distribution (peer rate limiting)	{T0-node,T8-polkadot}	t	f	\N	11	2024-05-02 12:05:37+00	\N	2024-09-25 14:49:58.209927+00	\N
368	4348	polkadot-sdk-frame is not released	{}	t	f	\N	11	2024-05-02 03:16:43+00	\N	2024-09-25 14:49:58.209927+00	\N
369	4338	Deprecated host functions that were supported in early releases of the substrate make a node unable to synchronize and verify the history from the genesis block.	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-04-30 14:45:05+00	\N	2024-09-25 14:49:58.209927+00	\N
370	4335	XCM Documentation: Creation and Use of Foreign Asset	{T6-XCM,T11-documentation}	t	f	\N	11	2024-04-30 13:27:58+00	\N	2024-09-25 14:49:58.209927+00	\N
371	4334	Add Statement Distribution V2/V3 Metrics	{T0-node,T8-polkadot,D0-easy,C2-good-first-issue}	t	f	\N	11	2024-04-30 11:49:46+00	\N	2024-09-25 14:49:58.209927+00	\N
372	4327	How many messages can we send right now per block	{}	t	f	\N	11	2024-04-29 16:28:38+00	\N	2024-09-25 14:49:58.209927+00	\N
373	4322	Support for dnsaddr websocket connections	{I5-enhancement}	t	f	\N	11	2024-04-29 08:57:24+00	\N	2024-09-25 14:49:58.209927+00	\N
374	4316	On Initialize should panic with input `0`	{}	t	f	\N	11	2024-04-28 09:41:24+00	\N	2024-09-25 14:49:58.209927+00	\N
375	4315	Define and implement `Hold` for Assets	{I5-enhancement}	t	f	\N	11	2024-04-28 06:55:01+00	\N	2024-09-25 14:49:58.209927+00	\N
376	4313	[Tracker] Add runtime apis to Kusama and Polkadot runtime	{}	t	f	\N	11	2024-04-26 20:26:01+00	\N	2024-09-25 14:49:58.209927+00	\N
377	4299	QR Standard for More Than Addresses	{I6-meta}	t	f	\N	11	2024-04-25 17:21:35+00	\N	2024-09-25 14:49:58.209927+00	\N
378	4292	Candidate should always be executed with executor parameters from the session it was produced in	{I2-bug}	t	f	\N	11	2024-04-25 11:58:49+00	\N	2024-09-25 14:49:58.209927+00	\N
379	4291	[bridge] AH to include BH execution fees in AH to BH leg of the transfer	{T15-bridges}	t	f	\N	11	2024-04-25 11:16:18+00	\N	2024-09-25 14:49:58.209927+00	\N
380	4287	Bump async backing parameters	{}	t	f	\N	11	2024-04-25 10:58:47+00	\N	2024-09-25 14:49:58.209927+00	\N
381	4286	Allow multiple assets to be transferred between AssetHubs over bridge	{T6-XCM,T15-bridges}	t	f	\N	11	2024-04-25 10:55:36+00	\N	2024-09-25 14:49:58.209927+00	\N
382	4284	XCM: Remove `require_weight_at_most` from Transact	{T6-XCM}	t	f	\N	11	2024-04-25 09:58:14+00	\N	2024-09-25 14:49:58.209927+00	\N
383	4268	merkleized-metadata crate	{I10-unconfirmed}	t	f	\N	11	2024-04-24 12:41:25+00	\N	2024-09-25 14:49:58.209927+00	\N
680	1973	Region merging	{}	t	f	\N	11	2023-10-22 13:54:05+00	\N	2024-09-25 14:49:58.209927+00	\N
384	4267	Improve the error information when using wrong type in signed extensions (ChargeAssetTxPayment) 	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-04-24 11:31:01+00	\N	2024-09-25 14:49:58.209927+00	\N
385	4255	`UncheckedExtrinsic` decoding improvements	{I9-optimisation}	t	f	\N	11	2024-04-23 10:43:43+00	\N	2024-09-25 14:49:58.209927+00	\N
386	4230	Polkadot Doppelganger	{T10-tests,D3-involved}	t	f	\N	11	2024-04-21 21:22:33+00	\N	2024-09-25 14:49:58.209927+00	\N
387	4227	`OnPollStatusChange` for `pallet-referenda`	{I5-enhancement}	t	f	\N	11	2024-04-21 16:15:32+00	\N	2024-09-25 14:49:58.209927+00	\N
388	4219	Network Time Security	{I10-unconfirmed}	t	f	\N	11	2024-04-19 15:19:15+00	\N	2024-09-25 14:49:58.209927+00	\N
389	4218	`author_submitAndWatchExtrinsic` can return `Finalized`/`InBlock` even though the tx-hash of the submission is not in the specified block	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-04-19 14:25:14+00	\N	2024-09-25 14:49:58.209927+00	\N
390	4217	Migrate `VirtualStakers` introduced in 3889 in `Ledger`.	{I10-unconfirmed}	t	f	\N	11	2024-04-19 14:02:18+00	\N	2024-09-25 14:49:58.209927+00	\N
391	4212	transfer_keep_alive call of assets pallet should allow to transfer the whole balance when the account existence is guaranteed.	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-04-19 09:55:14+00	\N	2024-09-25 14:49:58.209927+00	\N
392	4210	[benchmarking] `blocks_elapsed` in the test differs from `kitchensink`.	{T12-benchmarks}	t	f	\N	11	2024-04-19 09:02:31+00	\N	2024-09-25 14:49:58.209927+00	\N
393	4203	PVF: Consider re-preparing PVFs ahead of time if `PendingConfigs` changes `ExecutorParams`	{I9-optimisation}	t	f	\N	11	2024-04-18 15:58:02+00	\N	2024-09-25 14:49:58.209927+00	\N
394	4191	Implement XCM `ExecuteWithOrigin` instruction	{T6-XCM,I5-enhancement}	t	f	\N	11	2024-04-18 11:40:18+00	\N	2024-09-25 14:49:58.209927+00	\N
395	4190	Implement XCM Custom Asset Claimer instruction	{T6-XCM,I5-enhancement}	t	f	\N	11	2024-04-18 11:38:19+00	\N	2024-09-25 14:49:58.209927+00	\N
396	4184	rpc server: Subscription buffer limit exceeded	{}	t	f	\N	11	2024-04-17 17:54:55+00	\N	2024-09-25 14:49:58.209927+00	\N
397	4174	State Trie Migration	{}	t	f	\N	11	2024-04-17 12:18:27+00	\N	2024-09-25 14:49:58.209927+00	\N
398	4154	Add a new broker extrinsic to reserve immediately	{I5-enhancement,T2-pallets}	t	f	\N	11	2024-04-16 09:31:54+00	\N	2024-09-25 14:49:58.209927+00	\N
399	4139	Distributed validator infrastructure for Polkadot	{I10-unconfirmed}	t	f	\N	11	2024-04-15 20:40:43+00	\N	2024-09-25 14:49:58.209927+00	\N
400	4127	Support to debug (lldb) wasm execution of runtime	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-04-15 10:55:15+00	\N	2024-09-25 14:49:58.209927+00	\N
401	4126	Determine the sweet spot for num execute_workers_max_num & prepare_workers_max_num	{}	t	f	\N	11	2024-04-15 10:27:26+00	\N	2024-09-25 14:49:58.209927+00	\N
402	4125	Deprecation tracking issue for XCMv2	{T6-XCM,T13-deprecation}	t	f	\N	11	2024-04-15 10:15:12+00	\N	2024-09-25 14:49:58.209927+00	\N
403	4123	RFC: Meta Transaction Implementation	{}	t	f	\N	11	2024-04-15 10:04:47+00	\N	2024-09-25 14:49:58.209927+00	\N
404	4120	Consider removing GrandPa commit messages gossiping	{}	t	f	\N	11	2024-04-15 07:11:24+00	\N	2024-09-25 14:49:58.209927+00	\N
405	4110	Node side reversion logic is incomplete	{}	t	f	\N	11	2024-04-12 16:47:32+00	\N	2024-09-25 14:49:58.209927+00	\N
406	4109	Ignored block announcement because all validation slots for this peer are occupied	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-04-12 16:43:35+00	\N	2024-09-25 14:49:58.209927+00	\N
407	4108	[Meta] State of Disabling	{I6-meta}	t	f	\N	11	2024-04-12 15:21:47+00	\N	2024-09-25 14:49:58.209927+00	\N
408	4098	Extend metadata with deprecation	{I5-enhancement,T1-FRAME,T13-deprecation}	t	f	\N	11	2024-04-12 10:50:53+00	\N	2024-09-25 14:49:58.209927+00	\N
409	4092	A way to annotate and enforce a max size of call parameters	{}	t	f	\N	11	2024-04-12 04:05:35+00	\N	2024-09-25 14:49:58.209927+00	\N
410	4090	Add vestedTransfer for Assets on Asset Hub	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-04-11 19:32:16+00	\N	2024-09-25 14:49:58.209927+00	\N
411	4078	Add collator sanity test vs production network runtimes	{T10-tests}	t	f	\N	11	2024-04-11 09:44:18+00	\N	2024-09-25 14:49:58.209927+00	\N
412	4073	Inconsistencies of XCM NonFungible adapters. And an easy-to-introduce vulnerability	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-04-10 15:08:41+00	\N	2024-09-25 14:49:58.209927+00	\N
413	4047	Reduce group rotation on testnets (zombienet tests)	{T10-tests}	t	f	\N	11	2024-04-09 13:44:16+00	\N	2024-09-25 14:49:58.209927+00	\N
414	4046	mbm: `try-runtime` hooks for `SteppedMigration`	{I5-enhancement}	t	f	\N	11	2024-04-09 13:03:08+00	\N	2024-09-25 14:49:58.209927+00	\N
415	4045	Benchmark CI check ignores debug assertions	{T12-benchmarks}	t	f	\N	11	2024-04-09 12:23:02+00	\N	2024-09-25 14:49:58.209927+00	\N
416	4042	Visibility Test Issue	{}	t	f	\N	11	2024-04-09 10:30:52+00	\N	2024-09-25 14:49:58.209927+00	\N
417	4033	Generalize VariantCount into InstanceCount	{I5-enhancement,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2024-04-08 18:08:10+00	\N	2024-09-25 14:49:58.209927+00	\N
418	4030	On-demand Tutorial	{T11-documentation}	t	f	\N	11	2024-04-08 15:26:14+00	\N	2024-09-25 14:49:58.209927+00	\N
419	4023	Collator Protocol: Write RFC	{}	t	f	\N	11	2024-04-08 10:10:10+00	\N	2024-09-25 14:49:58.209927+00	\N
420	4011	[Benchmarking] Use `GenesisConfigBuilderRuntimeCaller` instead of raw WASM calls	{T1-FRAME,T12-benchmarks}	t	f	\N	11	2024-04-05 18:16:12+00	\N	2024-09-25 14:49:58.209927+00	\N
421	4010	[Benchmarking] `BenchmarkingState` should only use `Storage`	{T1-FRAME,T12-benchmarks}	t	f	\N	11	2024-04-05 18:14:37+00	\N	2024-09-25 14:49:58.209927+00	\N
422	4009	[FRAME] Verify `to_class_case` calls in Tasks API	{I10-unconfirmed}	t	f	\N	11	2024-04-05 18:09:15+00	\N	2024-09-25 14:49:58.209927+00	\N
423	4002	Cleanup the runtime	{}	t	f	\N	11	2024-04-05 14:27:06+00	\N	2024-09-25 14:49:58.209927+00	\N
424	4001	serde for RuntimeString is broken	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-04-05 14:14:12+00	\N	2024-09-25 14:49:58.209927+00	\N
425	3992	pallet assets: Admin can't transfer frozen asset contrary to documentation	{}	t	f	\N	11	2024-04-05 09:13:30+00	\N	2024-09-25 14:49:58.209927+00	\N
426	3991	`CheckNonce` should not enforce the account creation requirement for feeless calls	{T1-FRAME}	t	f	\N	11	2024-04-05 04:27:34+00	\N	2024-09-25 14:49:58.209927+00	\N
427	3977	Change identity raw data values to be generic Get<u32>	{C1-mentor,I5-enhancement,C2-good-first-issue}	t	f	\N	11	2024-04-04 07:19:48+00	\N	2024-09-25 14:49:58.209927+00	\N
428	3973	Grandpa benchmarks do not match Grandpa::WeightInfo Trait	{I2-bug}	t	f	\N	11	2024-04-03 18:56:52+00	\N	2024-09-25 14:49:58.209927+00	\N
429	3968	`fungibles` methods should not consume `AssetId`	{C1-mentor,T1-FRAME,C2-good-first-issue}	t	f	\N	11	2024-04-03 12:28:03+00	\N	2024-09-25 14:49:58.209927+00	\N
430	3967	slot-based-collator: Adjust ConsensusHook and parent search	{T0-node}	t	f	\N	11	2024-04-03 12:04:43+00	\N	2024-09-25 14:49:58.209927+00	\N
431	3966	slot-based-collator: Collation & block-builder communication	{T0-node}	t	f	\N	11	2024-04-03 11:55:37+00	\N	2024-09-25 14:49:58.209927+00	\N
432	3965	slot-based-collator: Allow slot drift	{T0-node}	t	f	\N	11	2024-04-03 11:50:00+00	\N	2024-09-25 14:49:58.209927+00	\N
681	1960	Offchain XCMP	{I6-meta}	t	f	\N	11	2023-10-20 16:36:09+00	\N	2024-09-25 14:49:58.209927+00	\N
433	3958	Asset Transactor on Asset Hubs not Working With Sufficient Assets	{T6-XCM,T14-system_parachains}	t	f	\N	11	2024-04-03 04:53:25+00	\N	2024-09-25 14:49:58.209927+00	\N
434	3945	Beefy mpsc channels clogging after warp-sync	{T0-node,I2-bug,I10-unconfirmed,T8-polkadot,D1-medium}	t	f	\N	11	2024-04-02 14:29:20+00	\N	2024-09-25 14:49:58.209927+00	\N
435	3916	Streamlining Templates Configuration with pallat Config Defaults	{}	t	f	\N	11	2024-03-31 17:47:34+00	\N	2024-09-25 14:49:58.209927+00	\N
436	3901	🎉 Wishlist: Users	{I6-meta}	t	f	\N	11	2024-03-29 15:53:03+00	\N	2024-09-25 14:49:58.209927+00	\N
437	3900	🧑‍💻 Wishlist: Developers 	{I6-meta}	t	f	\N	11	2024-03-29 15:49:20+00	\N	2024-09-25 14:49:58.209927+00	\N
438	3896	 BEEFY & GRANDPA: consider using a grid topology for gossip	{T0-node}	t	f	\N	11	2024-03-29 13:04:18+00	\N	2024-09-25 14:49:58.209927+00	\N
439	3888	Break StakingInterface into smaller traits	{I4-refactor}	t	f	\N	11	2024-03-29 08:44:01+00	\N	2024-09-25 14:49:58.209927+00	\N
440	3877	Extract `pallet_para_sudo_wrapper` into Its Own Crate	{}	t	f	\N	11	2024-03-28 10:56:52+00	\N	2024-09-25 14:49:58.209927+00	\N
441	3870	Restrict Vested Transfers to Self with Arbitrary Amount	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-03-27 17:11:38+00	\N	2024-09-25 14:49:58.209927+00	\N
442	3861	Allow One Chain to be an Account Provider for Another	{T6-XCM,T2-pallets}	t	f	\N	11	2024-03-27 13:58:13+00	\N	2024-09-25 14:49:58.209927+00	\N
443	3856	Westend People chain - not discovering peers	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-03-27 12:23:36+00	\N	2024-09-25 14:49:58.209927+00	\N
444	3855	Add Ability to `transact_as` on Target Locations	{T6-XCM,T2-pallets}	t	f	\N	11	2024-03-27 12:19:04+00	\N	2024-09-25 14:49:58.209927+00	\N
445	3847	pallet-xcm `transfer_assets` should take fees separately instead of using the index in assets	{T6-XCM,C1-mentor}	t	f	\N	11	2024-03-26 16:55:19+00	\N	2024-09-25 14:49:58.209927+00	\N
446	3846	`VersionedXcm` is not created with `versioned_type`	{T6-XCM,C1-mentor,D0-easy}	t	f	\N	11	2024-03-26 16:38:52+00	\N	2024-09-25 14:49:58.209927+00	\N
447	3838	Remove redundancy in collation generation	{I4-refactor}	t	f	\N	11	2024-03-26 10:19:50+00	\N	2024-09-25 14:49:58.209927+00	\N
448	3837	Look-ahead collator: build on all assigned cores	{I5-enhancement,T9-cumulus}	t	f	\N	11	2024-03-26 10:03:18+00	\N	2024-09-25 14:49:58.209927+00	\N
449	3824	authority-discovery: Allow signed DHT records only	{}	t	f	\N	11	2024-03-25 12:57:31+00	\N	2024-09-25 14:49:58.209927+00	\N
450	3823	authority-discovery: Publishing records strategy on DHT failures	{}	t	f	\N	11	2024-03-25 12:22:17+00	\N	2024-09-25 14:49:58.209927+00	\N
451	3797	Funds not `trapped` after `polkadotXcm.Attempted` returns `FailedToTransactAsset`	{T6-XCM,I2-bug,I10-unconfirmed}	t	f	\N	11	2024-03-22 12:50:01+00	\N	2024-09-25 14:49:58.209927+00	\N
452	3793	`frame-benchmarking-cli` should not build RocksDB	{D0-easy}	t	f	\N	11	2024-03-22 12:01:39+00	\N	2024-09-25 14:49:58.209927+00	\N
453	3783	Adjust `pallet_broker::start_sales` benchmark to work with actual `PriceAdapter` implementation 	{T12-benchmarks}	t	f	\N	11	2024-03-21 14:40:52+00	\N	2024-09-25 14:49:58.209927+00	\N
454	3771	Deprecation tracking issue for pallet-xcm `execute` and `send`	{T13-deprecation}	t	f	\N	11	2024-03-20 16:58:42+00	\N	2024-09-25 14:49:58.209927+00	\N
455	3756	Reconsider the way runtime version checks are performed on node side	{T0-node,I9-optimisation,T8-polkadot}	t	f	\N	11	2024-03-20 07:06:28+00	\N	2024-09-25 14:49:58.209927+00	\N
456	3750	Consider using `CountedMap` for ledger-related storages	{C1-mentor,I4-refactor,I10-unconfirmed}	t	f	\N	11	2024-03-19 23:45:14+00	\N	2024-09-25 14:49:58.209927+00	\N
457	3743	FRAME: Simplify and extend pallets config definition by using the stabilized feature: associated type bounds	{T1-FRAME,D2-substantial}	t	f	\N	11	2024-03-19 12:01:04+00	\N	2024-09-25 14:49:58.209927+00	\N
458	3728	Enable all `try-state` checks in staking 	{T10-tests}	t	f	\N	11	2024-03-18 09:08:30+00	\N	2024-09-25 14:49:58.209927+00	\N
459	3709	message queue regression compare to dmp queue	{}	t	f	\N	11	2024-03-15 07:33:50+00	\N	2024-09-25 14:49:58.209927+00	\N
460	3705	Export api from the transaction pool to query ready transaction by tag	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-03-14 21:10:31+00	\N	2024-09-25 14:49:58.209927+00	\N
461	3703	[FRAME] Fuzzmarks	{T12-benchmarks,D2-substantial}	t	f	\N	11	2024-03-14 19:04:10+00	\N	2024-09-25 14:49:58.209927+00	\N
462	3699	Elastic Scaling: Guide Changes	{}	t	f	\N	11	2024-03-14 16:11:44+00	\N	2024-09-25 14:49:58.209927+00	\N
463	3697	Consider implementing a `checked_mutate` for all the mutations in the staking ledger related storage items  	{C1-mentor,I10-unconfirmed,C2-good-first-issue}	t	f	\N	11	2024-03-14 14:10:42+00	\N	2024-09-25 14:49:58.209927+00	\N
464	3692	Lowering XCM weights and fees	{T6-XCM}	t	f	\N	11	2024-03-14 09:57:13+00	\N	2024-09-25 14:49:58.209927+00	\N
465	3688	[Frame Core] Construct Runtime V2 follow-ups	{I6-meta,T1-FRAME}	t	f	\N	11	2024-03-14 04:16:27+00	\N	2024-09-25 14:49:58.209927+00	\N
466	3686	[CI] Prevent introduction of flaky tests	{}	t	f	\N	11	2024-03-13 20:09:07+00	\N	2024-09-25 14:49:58.209927+00	\N
467	3683	[FRAME] Executive invariant fuzzer	{C1-mentor,T10-tests,D1-medium,C2-good-first-issue}	t	f	\N	11	2024-03-13 16:43:21+00	\N	2024-09-25 14:49:58.209927+00	\N
468	3676	[FRAME] Deprecate old scheduler traits	{C1-mentor,T13-deprecation,D0-easy,C2-good-first-issue}	t	f	\N	11	2024-03-13 12:20:57+00	\N	2024-09-25 14:49:58.209927+00	\N
469	3672	A time based scheduler	{I5-enhancement}	t	f	\N	11	2024-03-13 03:37:38+00	\N	2024-09-25 14:49:58.209927+00	\N
470	3662	[FRAME] Remove `is_inherent_required`	{T13-deprecation,D0-easy}	t	f	\N	11	2024-03-12 13:25:05+00	\N	2024-09-25 14:49:58.209927+00	\N
471	3661	PolkadotXCM Reserve Transfer Asset with Multiple Asset and FeeItem is Zero (0)	{T6-XCM,I2-bug,I10-unconfirmed}	t	f	\N	11	2024-03-12 12:46:34+00	\N	2024-09-25 14:49:58.209927+00	\N
472	3655	Remove deps to `parity-bip39`	{}	t	f	\N	11	2024-03-12 10:26:45+00	\N	2024-09-25 14:49:58.209927+00	\N
473	3647	[FRAME] Named account references	{I5-enhancement,D2-substantial}	t	f	\N	11	2024-03-11 15:26:15+00	\N	2024-09-25 14:49:58.209927+00	\N
474	3622	Enable PoV Reclaim on runtimes	{}	t	f	\N	11	2024-03-08 11:44:10+00	\N	2024-09-25 14:49:58.209927+00	\N
475	3617	improve fellowshipCore.setParams and related code	{C1-mentor,I4-refactor,T2-pallets,D1-medium,C2-good-first-issue}	t	f	\N	11	2024-03-08 00:56:08+00	\N	2024-09-25 14:49:58.209927+00	\N
476	3610	[NPoS] Pagify slashing	{T1-FRAME}	t	f	\N	11	2024-03-07 12:21:02+00	\N	2024-09-25 14:49:58.209927+00	\N
477	3603	Fix hanging `instant_seal_delayed_finalize` test and enable it again	{}	t	f	\N	11	2024-03-07 03:17:10+00	\N	2024-09-25 14:49:58.209927+00	\N
478	3600	subsystem-bench: Extract prometheus endpoint launching from regression test cases to use it only with cli runner	{R0-silent,C1-mentor,T12-benchmarks,C2-good-first-issue}	t	f	\N	11	2024-03-06 13:35:06+00	\N	2024-09-25 14:49:58.209927+00	\N
479	3596	Custom relay chain stalling after a day	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-03-06 12:29:47+00	\N	2024-09-25 14:49:58.209927+00	\N
480	3594	Subscribe-able runtime apis	{T0-node,T3-RPC_API,T4-runtime_API}	t	f	\N	11	2024-03-06 11:25:23+00	\N	2024-09-25 14:49:58.209927+00	\N
481	3593	Add example usage in docs of `TransactionExtension` use with general, new-school transactions	{}	t	f	\N	11	2024-03-06 10:27:45+00	\N	2024-09-25 14:49:58.209927+00	\N
482	3592	Update `UncheckedExtrinsic` documentation	{}	t	f	\N	11	2024-03-06 09:51:49+00	\N	2024-09-25 14:49:58.209927+00	\N
483	3591	Revisit reference docs for `TransactionExtension`	{}	t	f	\N	11	2024-03-06 09:44:16+00	\N	2024-09-25 14:49:58.209927+00	\N
484	3590	Ocassional false positive of  `Declared as collator for unneeded`	{}	t	f	\N	11	2024-03-06 09:30:26+00	\N	2024-09-25 14:49:58.209927+00	\N
485	3581	[FRAME] Warn when using default `SubstrateWeights` in production	{}	t	f	\N	11	2024-03-05 14:27:34+00	\N	2024-09-25 14:49:58.209927+00	\N
486	3572	Add benchmarks to `StorageWeightReclaim`	{T1-FRAME}	t	f	\N	11	2024-03-05 08:35:35+00	\N	2024-09-25 14:49:58.209927+00	\N
487	3571	Break up `trait Extrinsic` into logical components	{T1-FRAME}	t	f	\N	11	2024-03-05 08:30:52+00	\N	2024-09-25 14:49:58.209927+00	\N
488	3561	The node should shutdown if `SyncingEngine` event loop terminates	{I2-bug}	t	f	\N	11	2024-03-04 13:41:16+00	\N	2024-09-25 14:49:58.209927+00	\N
489	3555	[FRAME] Run benchmark tests with real Runtimes	{I5-enhancement,T12-benchmarks}	t	f	\N	11	2024-03-03 15:29:32+00	\N	2024-09-25 14:49:58.209927+00	\N
490	3551	Simplify Polkadot Subsystem Architecture	{}	t	f	\N	11	2024-03-02 10:59:14+00	\N	2024-09-25 14:49:58.209927+00	\N
491	3549	Configurable (via Governance Call) Funds Distribution	{T2-pallets}	t	f	\N	11	2024-03-02 06:13:17+00	\N	2024-09-25 14:49:58.209927+00	\N
492	3546	Add new dispatchables to PalletXcm to allow remote locking 	{T6-XCM,I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-03-01 16:26:22+00	\N	2024-09-25 14:49:58.209927+00	\N
493	3533	clippy::multiple_bound_locations reported on sp_api::decl_runtime_apis!	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-02-29 20:37:48+00	\N	2024-09-25 14:49:58.209927+00	\N
494	3519	rococo asset-hub and others don't always advertise their collations 	{}	t	f	\N	11	2024-02-29 08:08:14+00	\N	2024-09-25 14:49:58.209927+00	\N
495	3515	Bypass supertrait ref doc or blog post	{T11-documentation}	t	f	\N	11	2024-02-29 00:00:05+00	\N	2024-09-25 14:49:58.209927+00	\N
496	3507	Remove obsolete parachain pallets	{}	t	f	\N	11	2024-02-28 11:47:14+00	\N	2024-09-25 14:49:58.209927+00	\N
497	3500	Document multi-block migrations in migration ref doc	{T11-documentation}	t	f	\N	11	2024-02-28 05:53:23+00	\N	2024-09-25 14:49:58.209927+00	\N
498	3499	New, more flexible `try-runtime` runtime apis	{T1-FRAME,T4-runtime_API}	t	f	\N	11	2024-02-28 01:58:40+00	\N	2024-09-25 14:49:58.209927+00	\N
499	3472	CAUSED BY A DDOS attack: Thread 'tokio-runtime-worker' panicked at 'A Tokio 1.x context was found, but it is being shutdown. 	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-02-24 23:36:54+00	\N	2024-09-25 14:49:58.209927+00	\N
500	3470	[pallet-xcm / pallet-xcm-benchmarks] Improvements	{T6-XCM}	t	f	\N	11	2024-02-23 17:46:04+00	\N	2024-09-25 14:49:58.209927+00	\N
501	3451	[Assets] Allow per-account freeze / thaw for all assets with the same freezer	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-02-22 19:03:59+00	\N	2024-09-25 14:49:58.209927+00	\N
502	3449	Avoid compiling the same wasm twice because of `GenesisBlockBuilder`	{I5-enhancement}	t	f	\N	11	2024-02-22 17:44:06+00	\N	2024-09-25 14:49:58.209927+00	\N
503	3434	Better delivery fees: DepositFee	{T6-XCM,I5-enhancement}	t	f	\N	11	2024-02-21 16:23:15+00	\N	2024-09-25 14:49:58.209927+00	\N
504	3421	backing: improve session buffering for runtime information	{T0-node,I9-optimisation,T8-polkadot}	t	f	\N	11	2024-02-21 10:56:19+00	\N	2024-09-25 14:49:58.209927+00	\N
505	3420	Make pallet_referenda::TracksInfo::tracks return type more flexible	{}	t	f	\N	11	2024-02-21 10:29:30+00	\N	2024-09-25 14:49:58.209927+00	\N
506	3406	Coretime: Polkadot	{}	t	f	\N	11	2024-02-20 12:50:22+00	\N	2024-09-25 14:49:58.209927+00	\N
507	3402	Remove parathreads	{}	t	f	\N	11	2024-02-20 11:08:12+00	\N	2024-09-25 14:49:58.209927+00	\N
508	3387	Secure collator mode	{I5-enhancement}	t	f	\N	11	2024-02-19 11:28:04+00	\N	2024-09-25 14:49:58.209927+00	\N
509	3369	Consider enabling client/server support for Kademlia	{I5-enhancement}	t	f	\N	11	2024-02-17 09:02:16+00	\N	2024-09-25 14:49:58.209927+00	\N
510	3368	Reconsider if we should connect/accept reserved nodes if they are banned by the reputation system	{I3-annoyance}	t	f	\N	11	2024-02-17 08:41:05+00	\N	2024-09-25 14:49:58.209927+00	\N
511	3365	Consider adding a new dispute status `Pending`	{}	t	f	\N	11	2024-02-16 17:50:51+00	\N	2024-09-25 14:49:58.209927+00	\N
512	3338	[CI] Prevent suffixed crate versions	{}	t	f	\N	11	2024-02-15 12:43:49+00	\N	2024-09-25 14:49:58.209927+00	\N
513	3332	[FRAME] `Currency::transfer()` can create locks if used incorrectly	{I3-annoyance}	t	f	\N	11	2024-02-15 09:01:18+00	\N	2024-09-25 14:49:58.209927+00	\N
514	3326	[Deprecation] remove `pallet::getter` usage from all pallets	{I4-refactor,T2-pallets}	t	f	\N	11	2024-02-14 14:34:14+00	\N	2024-09-25 14:49:58.209927+00	\N
515	3291	 [RelEng] Automate node release process	{}	t	f	\N	11	2024-02-12 13:42:35+00	\N	2024-09-25 14:49:58.209927+00	\N
516	3290	[RelEng] Automate crates-io release process	{}	t	f	\N	11	2024-02-12 13:41:31+00	\N	2024-09-25 14:49:58.209927+00	\N
517	3288	Make `Any` Proxies Copyable from a Configured Source	{T6-XCM,T2-pallets}	t	f	\N	11	2024-02-12 10:11:05+00	\N	2024-09-25 14:49:58.209927+00	\N
518	3283	Add Moonwall test suit in the node template	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2024-02-10 16:53:37+00	\N	2024-09-25 14:49:58.209927+00	\N
519	3270	Shorter availability data retention period for testnets	{T0-node,T8-polkadot}	t	f	\N	11	2024-02-08 16:58:01+00	\N	2024-09-25 14:49:58.209927+00	\N
520	3268	[FRAME] Prepare pallets for dynamic block durations	{}	t	f	\N	11	2024-02-08 15:50:53+00	\N	2024-09-25 14:49:58.209927+00	\N
521	3245	[Staking] `check_payees` try-state check failing in Westend	{T2-pallets,T10-tests}	t	f	\N	11	2024-02-07 21:46:41+00	\N	2024-09-25 14:49:58.209927+00	\N
522	3242	Build bridges testing framework	{T10-tests,T15-bridges}	t	f	\N	11	2024-02-07 15:07:58+00	\N	2024-09-25 14:49:58.209927+00	\N
523	3238	[FRAME] pallet::dynamic_parameter attribute	{}	t	f	\N	11	2024-02-07 06:16:45+00	\N	2024-09-25 14:49:58.209927+00	\N
524	3218	`OpaqueKeys::ownership_proof_is_valid` default implementation returns true, and is never overridden	{}	t	f	\N	11	2024-02-06 05:21:03+00	\N	2024-09-25 14:49:58.209927+00	\N
525	3216	Even smarter full availability recovery from backers	{I9-optimisation,I5-enhancement}	t	f	\N	11	2024-02-05 19:41:36+00	\N	2024-09-25 14:49:58.209927+00	\N
526	3214	[xcm/pallet_xcm] New XCM version change improvements	{T6-XCM}	t	f	\N	11	2024-02-05 15:29:24+00	\N	2024-09-25 14:49:58.209927+00	\N
527	3210	Allow `ranked-collective` voting with ranks below the minimum	{C1-mentor,I5-enhancement,D0-easy}	t	f	\N	11	2024-02-05 11:53:24+00	\N	2024-09-25 14:49:58.209927+00	\N
528	3201	Broker: Use relay chain blocks for `leadin_length` and `interlude_length`	{C1-mentor,I4-refactor}	t	f	\N	11	2024-02-05 06:27:44+00	\N	2024-09-25 14:49:58.209927+00	\N
529	3198	SetAppendix(ReportError(QueryResponseInfo)) instruction stopped reporting xcm execution result	{T6-XCM,I2-bug,I10-unconfirmed}	t	f	\N	11	2024-02-04 11:17:28+00	\N	2024-09-25 14:49:58.209927+00	\N
530	3197	Thread 'tokio-runtime-worker' panicked at 'Integer overflow when casting to u64'	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-02-04 06:20:45+00	\N	2024-09-25 14:49:58.209927+00	\N
531	3180	Assert any candidate doesn't timeout with async backing	{}	t	f	\N	11	2024-02-02 08:21:46+00	\N	2024-09-25 14:49:58.209927+00	\N
532	3178	Refactor staking test modules into own files	{C1-mentor,T1-FRAME,T10-tests,D0-easy}	t	f	\N	11	2024-02-01 17:30:14+00	\N	2024-09-25 14:49:58.209927+00	\N
533	3176	Run the bridges zombienet tests in the CI	{T10-tests,T15-bridges}	t	f	\N	11	2024-02-01 17:09:29+00	\N	2024-09-25 14:49:58.209927+00	\N
534	3168	Slot based collations	{}	t	f	\N	11	2024-02-01 10:08:47+00	\N	2024-09-25 14:49:58.209927+00	\N
535	3163	substrate not compiling on wsl on win10	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-02-01 02:57:56+00	\N	2024-09-25 14:49:58.209927+00	\N
536	3161	Update the build instructions of contracts-rococo 	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-01-31 17:15:14+00	\N	2024-09-25 14:49:58.209927+00	\N
537	3149	[Asset Conversion] Incentives Extension	{T2-pallets}	t	f	\N	11	2024-01-31 08:27:48+00	\N	2024-09-25 14:49:58.209927+00	\N
538	3145	[HRMP] Make `max_message_size` adjustable	{}	t	f	\N	11	2024-01-30 18:40:07+00	\N	2024-09-25 14:49:58.209927+00	\N
539	3138	Pallet macro expand produces unused import in some cases	{I2-bug}	t	f	\N	11	2024-01-30 13:43:49+00	\N	2024-09-25 14:49:58.209927+00	\N
541	3078	[RPC-Spec-V2] `chainHead_unstable_follow` shouldn't use `pipe_from_stream`	{T3-RPC_API,D1-medium}	t	f	\N	11	2024-01-26 11:29:43+00	\N	2024-09-25 14:49:58.209927+00	\N
542	3067	Splitting code inside impl_runtime_apis!  macro into separate files	{T1-FRAME}	t	f	\N	11	2024-01-25 18:25:39+00	\N	2024-09-25 14:49:58.209927+00	\N
543	3054	[cumulus] Clean `parachains-common`	{}	t	f	\N	11	2024-01-24 21:56:24+00	\N	2024-09-25 14:49:58.209927+00	\N
544	3038	Review all functions that accept Location and AssetId	{T6-XCM,C2-good-first-issue}	t	f	\N	11	2024-01-24 03:42:36+00	\N	2024-09-25 14:49:58.209927+00	\N
545	3031	Custom metadata for internal crates	{}	t	f	\N	11	2024-01-23 12:52:43+00	\N	2024-09-25 14:49:58.209927+00	\N
546	3005	Improve debuggability in wasm	{C1-mentor,I4-refactor,D0-easy,C2-good-first-issue}	t	f	\N	11	2024-01-19 19:48:40+00	\N	2024-09-25 14:49:58.209927+00	\N
547	2998	Implement Coretime credits	{I5-enhancement}	t	f	\N	11	2024-01-19 11:43:47+00	\N	2024-09-25 14:49:58.209927+00	\N
548	2997	[pallet_balances] Align `FreezeIdentifier`, `RuntimeFreezeReason` and `MaxFreezes`	{}	t	f	\N	11	2024-01-19 11:28:11+00	\N	2024-09-25 14:49:58.209927+00	\N
549	2984	Bound `CandidateDescriptor` to `core` and not `para_id`	{I4-refactor,D1-medium}	t	f	\N	11	2024-01-18 13:02:32+00	\N	2024-09-25 14:49:58.209927+00	\N
550	2972	[nomination pools] add stash account info to the nomination pools storage 	{I5-enhancement}	t	f	\N	11	2024-01-17 20:19:49+00	\N	2024-09-25 14:49:58.209927+00	\N
551	2948	need to set_keys in pallet_session in running chain	{I10-unconfirmed}	t	f	\N	11	2024-01-16 17:38:10+00	\N	2024-09-25 14:49:58.209927+00	\N
552	2930	[CI] Generate `README`s from crate docs	{I5-enhancement,D1-medium}	t	f	\N	11	2024-01-15 11:02:50+00	\N	2024-09-25 14:49:58.209927+00	\N
553	2916	Last two crates.io release rounds seem not related to official polkadot-sdk repo	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-01-11 13:51:54+00	\N	2024-09-25 14:49:58.209927+00	\N
554	2906	[system parachain testnets] Add `cumulus_pallet_parachain_system` to benchmarks for all SP runtimes	{}	t	f	\N	11	2024-01-10 14:51:10+00	\N	2024-09-25 14:49:58.209927+00	\N
555	2904	[collectives-westend] Setup xcm benchmarked weights instead of `FixedWeightBounds`	{C1-mentor,T14-system_parachains,C2-good-first-issue}	t	f	\N	11	2024-01-10 13:43:11+00	\N	2024-09-25 14:49:58.209927+00	\N
556	2892	Distribute arm64 polkadot docker image	{}	t	f	\N	11	2024-01-09 15:55:26+00	\N	2024-09-25 14:49:58.209927+00	\N
557	2888	Switch frame-benchmarking to runtime APIs	{T1-FRAME,T4-runtime_API,T12-benchmarks}	t	f	\N	11	2024-01-09 13:48:34+00	\N	2024-09-25 14:49:58.209927+00	\N
558	2880	[polkadot-fellows/runtimes/pull/108] Added Polkadot <> Kusama bridge configuration	{I10-unconfirmed}	t	f	\N	11	2024-01-08 16:25:32+00	\N	2024-09-25 14:49:58.209927+00	\N
559	2874	Clean up configurations in staking once Parameter pallet is deployed	{T2-pallets}	t	f	\N	11	2024-01-08 01:13:38+00	\N	2024-09-25 14:49:58.209927+00	\N
560	2857	Make `SessionKeys` versioned	{I4-refactor}	t	f	\N	11	2024-01-05 12:12:46+00	\N	2024-09-25 14:49:58.209927+00	\N
561	2852	[FRAME] `pallet::stored` attribute for types	{I5-enhancement}	t	f	\N	11	2024-01-04 11:18:03+00	\N	2024-09-25 14:49:58.209927+00	\N
562	2851	move deposit to the new owner when buying an NFT.	{}	t	f	\N	11	2024-01-04 11:04:53+00	\N	2024-09-25 14:49:58.209927+00	\N
563	2841	On the deprecation of checkInherents	{}	t	f	\N	11	2024-01-03 08:56:20+00	\N	2024-09-25 14:49:58.209927+00	\N
564	2838	sp-runtime unconditionally depends on simple-mermaid	{}	t	f	\N	11	2024-01-02 17:36:01+00	\N	2024-09-25 14:49:58.209927+00	\N
565	2827	failed to spawn a prepare worker: TmpPath	{C1-mentor,I2-bug,I10-unconfirmed,D1-medium}	t	f	\N	11	2023-12-29 13:07:21+00	\N	2024-09-25 14:49:58.209927+00	\N
566	2819	Coretime: Provide guide/template to purchase coretime for a parachain.	{}	t	f	\N	11	2023-12-28 07:43:32+00	\N	2024-09-25 14:49:58.209927+00	\N
567	2817	Kusama System Chains should be ported to use async backing	{}	t	f	\N	11	2023-12-27 16:28:14+00	\N	2024-09-25 14:49:58.209927+00	\N
568	2816	Rococo System Chains should use async backing	{}	t	f	\N	11	2023-12-27 16:27:46+00	\N	2024-09-25 14:49:58.209927+00	\N
569	2812	Implement RFC 56	{I10-unconfirmed}	t	f	\N	11	2023-12-26 09:32:16+00	\N	2024-09-25 14:49:58.209927+00	\N
570	2809	The versions of the primitive packages are not synced with crates.io	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-12-25 22:38:45+00	\N	2024-09-25 14:49:58.209927+00	\N
571	2808	The version management of primitive packages is too radical	{I10-unconfirmed}	t	f	\N	11	2023-12-25 22:17:56+00	\N	2024-09-25 14:49:58.209927+00	\N
572	2791	impl guide: document coretime changes	{T11-documentation}	t	f	\N	11	2023-12-22 11:29:06+00	\N	2024-09-25 14:49:58.209927+00	\N
573	2790	Improve UX/docs of `OnGenesis`	{T1-FRAME,T11-documentation}	t	f	\N	11	2023-12-22 11:24:53+00	\N	2024-09-25 14:49:58.209927+00	\N
574	2780	[xcm] Investigate the possibility of `ProcessXcmMessage` / `XcmExecutor` emitting an event on failure.	{T6-XCM}	t	f	\N	11	2023-12-21 22:05:01+00	\N	2024-09-25 14:49:58.209927+00	\N
575	2774	Polkadot 1.5.0 dev chain not starting	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-12-21 17:16:40+00	\N	2024-09-25 14:49:58.209927+00	\N
576	2773	Coretime: Move interfacing to coretime chain to runtime level	{}	t	f	\N	11	2023-12-21 14:50:35+00	\N	2024-09-25 14:49:58.209927+00	\N
577	2766	Improve XCM weight generation devex	{T6-XCM,T12-benchmarks}	t	f	\N	11	2023-12-20 16:02:29+00	\N	2024-09-25 14:49:58.209927+00	\N
578	2762	[FRAME] Pallet hook for the first time a pallet is added to the runtime	{C1-mentor,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2023-12-20 09:06:41+00	\N	2024-09-25 14:49:58.209927+00	\N
579	2750	Unable to run the substrate dockerfile 	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-12-19 05:49:10+00	\N	2024-09-25 14:49:58.209927+00	\N
580	2745	Embed metadata into the wasm binary	{}	t	f	\N	11	2023-12-19 01:48:12+00	\N	2024-09-25 14:49:58.209927+00	\N
581	2739	PVF host: run coverage and/or miri	{T0-node,T10-tests}	t	f	\N	11	2023-12-18 14:07:27+00	\N	2024-09-25 14:49:58.209927+00	\N
582	2738	Store justifications obtained while warp syncing	{I5-enhancement,D0-easy}	t	f	\N	11	2023-12-18 14:07:18+00	\N	2024-09-25 14:49:58.209927+00	\N
583	2733	Do not prune session change justifications	{D0-easy}	t	f	\N	11	2023-12-18 10:37:12+00	\N	2024-09-25 14:49:58.209927+00	\N
584	2728	Got Essential task `overseer` failed error after upgrading Kusama and Polkadot validator to v1.5.0	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-12-17 23:10:05+00	\N	2024-09-25 14:49:58.209927+00	\N
585	2723	Coretime: Set initial parameters (prices)	{}	t	f	\N	11	2023-12-15 13:39:23+00	\N	2024-09-25 14:49:58.209927+00	\N
586	2708	Substrate: GPL-3.0 licence violation since release v1.4.0	{}	t	f	\N	11	2023-12-14 10:02:30+00	\N	2024-09-25 14:49:58.209927+00	\N
587	2699	BEEFY: Error when using fast sync and BEEFY genesis is 1	{I2-bug}	t	f	\N	11	2023-12-13 08:35:40+00	\N	2024-09-25 14:49:58.209927+00	\N
588	2678	approval-distribution: Evaluate reducing DEFAULT_RANDOM_CIRCULATION	{T8-polkadot}	t	f	\N	11	2023-12-11 07:04:49+00	\N	2024-09-25 14:49:58.209927+00	\N
589	2665	Investigate passing pallet index as const value	{C1-mentor,I5-enhancement,D0-easy,D2-substantial}	t	f	\N	11	2023-12-08 16:50:16+00	\N	2024-09-25 14:49:58.209927+00	\N
590	2650	Consider removing/simplifying `SlashingSpans` and `SpanSlash` from staking pallet	{}	t	f	\N	11	2023-12-07 12:18:17+00	\N	2024-09-25 14:49:58.209927+00	\N
591	2642	[CI] Check for excessive warnings in CI	{}	t	f	\N	11	2023-12-06 18:33:47+00	\N	2024-09-25 14:49:58.209927+00	\N
592	2636	Wasm runtime compilation is largely single-threaded	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-12-06 05:33:25+00	\N	2024-09-25 14:49:58.209927+00	\N
593	2622	Determine impact of missing back-off	{}	t	f	\N	11	2023-12-05 10:14:42+00	\N	2024-09-25 14:49:58.209927+00	\N
594	2613	[xcm-emulator] Make a generic constructor method for genesis `Storage`	{I4-refactor,T10-tests}	t	f	\N	11	2023-12-04 19:09:47+00	\N	2024-09-25 14:49:58.209927+00	\N
595	2605	Custom child trie	{}	t	f	\N	11	2023-12-04 15:58:10+00	\N	2024-09-25 14:49:58.209927+00	\N
596	2582	Core Time: Documentation	{T11-documentation}	t	f	\N	11	2023-12-01 18:23:55+00	\N	2024-09-25 14:49:58.209927+00	\N
597	2577	Remove slashed validators from active authority set for rest of era	{T0-node}	t	f	\N	11	2023-12-01 12:45:28+00	\N	2024-09-25 14:49:58.209927+00	\N
598	2568	`0002-validators-warp-sync` test failing	{}	t	f	\N	11	2023-11-30 14:05:52+00	\N	2024-09-25 14:49:58.209927+00	\N
599	2563	Use pallet `trait Config`  also for the `Call` interface	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-11-30 08:50:46+00	\N	2024-09-25 14:49:58.209927+00	\N
600	2551	`polkadot-service` does not compile without default features	{}	t	f	\N	11	2023-11-29 20:04:46+00	\N	2024-09-25 14:49:58.209927+00	\N
601	2541	Improve developer experience by removing `timepoint` from `multisig`	{I10-unconfirmed}	t	f	\N	11	2023-11-29 12:13:58+00	\N	2024-09-25 14:49:58.209927+00	\N
602	2536	Remove `NativeElseWasmExecutor` and deprecate it	{}	t	f	\N	11	2023-11-29 09:48:34+00	\N	2024-09-25 14:49:58.209927+00	\N
603	2505	CI: Output seems to be missing last logs	{I10-unconfirmed}	t	f	\N	11	2023-11-27 12:55:43+00	\N	2024-09-25 14:49:58.209927+00	\N
604	2500	Staking: Controller Deprecation Step by Step & Tracking Issue	{}	t	f	\N	11	2023-11-27 05:02:58+00	\N	2024-09-25 14:49:58.209927+00	\N
605	2499	consider refactor CliConfiguration in such way to reduce its footgun factor	{C1-mentor,I4-refactor,D1-medium}	t	f	\N	11	2023-11-27 00:30:47+00	\N	2024-09-25 14:49:58.209927+00	\N
606	2494	Remote Externalities: Start downloading KVs early	{T0-node,C1-mentor,I5-enhancement,D1-medium}	t	f	\N	11	2023-11-25 13:21:57+00	\N	2024-09-25 14:49:58.209927+00	\N
607	2479	Make Recovery Work Network-Wide	{T6-XCM,T2-pallets}	t	f	\N	11	2023-11-24 09:46:05+00	\N	2024-09-25 14:49:58.209927+00	\N
608	2470	[FRAME] Pallet `SafeMode` rejects inherents	{I3-annoyance}	t	f	\N	11	2023-11-23 14:12:46+00	\N	2024-09-25 14:49:58.209927+00	\N
609	2465	Move documentation from staking pallet from README to rustdocs	{T11-documentation}	t	f	\N	11	2023-11-23 11:01:40+00	\N	2024-09-25 14:49:58.209927+00	\N
610	2460	`assert_expected_events!` gives false positives on inner enum values 	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-11-22 23:41:39+00	\N	2024-09-25 14:49:58.209927+00	\N
611	2452	`remote-externalities` can fail to download values for extremely large keys	{I2-bug}	t	f	\N	11	2023-11-22 17:34:41+00	\N	2024-09-25 14:49:58.209927+00	\N
612	2436	Deprecate `ValidateUnsigned` and `#[validate_unsigned]`	{C1-mentor,T13-deprecation,D0-easy}	t	f	\N	11	2023-11-21 22:48:44+00	\N	2024-09-25 14:49:58.209927+00	\N
613	2423	XCM: support multiple assets transfers while still enforcing single asset for `BuyExecution`	{T6-XCM,I5-enhancement}	t	f	\N	11	2023-11-21 13:21:28+00	\N	2024-09-25 14:49:58.209927+00	\N
614	2421	FRAME: #[run_only_once] for top-level migration	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-11-21 12:40:57+00	\N	2024-09-25 14:49:58.209927+00	\N
615	2418	Re-enable small offenders when disabled validators count reaches the disabling limit	{}	t	f	\N	11	2023-11-21 11:17:55+00	\N	2024-09-25 14:49:58.209927+00	\N
616	2417	XCM: `SubscribeVersion` doesn't work over bridge(s)	{T6-XCM,I2-bug,T15-bridges}	t	f	\N	11	2023-11-21 10:46:22+00	\N	2024-09-25 14:49:58.209927+00	\N
617	2416	Improve XCM emulator `decl_test_parachains` semantics and docs	{C1-mentor,I5-enhancement,T10-tests,T11-documentation,C2-good-first-issue}	t	f	\N	11	2023-11-20 19:27:56+00	\N	2024-09-25 14:49:58.209927+00	\N
618	2415	Extrinsic Horizon	{}	t	f	\N	11	2023-11-20 17:12:10+00	\N	2024-09-25 14:49:58.209927+00	\N
619	2410	CI: Add code coverage	{T10-tests}	t	f	\N	11	2023-11-20 06:44:14+00	\N	2024-09-25 14:49:58.209927+00	\N
620	2408	[XCM] don't ignore errors	{T6-XCM,C1-mentor,I4-refactor,D0-easy,C2-good-first-issue}	t	f	\N	11	2023-11-20 06:20:57+00	\N	2024-09-25 14:49:58.209927+00	\N
621	2401	Remove `StakingAccount` and related code when controllers are removed from that staking codebase	{}	t	f	\N	11	2023-11-19 19:17:07+00	\N	2024-09-25 14:49:58.209927+00	\N
622	2399	PVF: Re-check file integrity before voting against; document	{T0-node,C1-mentor}	t	f	\N	11	2023-11-19 18:03:14+00	\N	2024-09-25 14:49:58.209927+00	\N
623	2391	Use channels instead of Arc in RPC FullDeps	{I10-unconfirmed}	t	f	\N	11	2023-11-18 05:07:51+00	\N	2024-09-25 14:49:58.209927+00	\N
624	2386	Improve BEEFY sync from genesis performance	{}	t	f	\N	11	2023-11-17 16:33:35+00	\N	2024-09-25 14:49:58.209927+00	\N
625	2382	statement-distribution: refactor setup/connection logic for tests	{}	t	f	\N	11	2023-11-17 12:55:36+00	\N	2024-09-25 14:49:58.209927+00	\N
626	2364	Sassafras Pallet Extensions	{I5-enhancement}	t	f	\N	11	2023-11-16 15:26:35+00	\N	2024-09-25 14:49:58.209927+00	\N
627	2353	Core time: Kusama	{}	t	f	\N	11	2023-11-15 16:35:29+00	\N	2024-09-25 14:49:58.209927+00	\N
628	2349	pallet-session doesn't enable setting weights, removing the ability to weight Grandpa	{I10-unconfirmed}	t	f	\N	11	2023-11-15 14:59:26+00	\N	2024-09-25 14:49:58.209927+00	\N
629	2329	Increase test coverage for statement-distribution	{}	t	f	\N	11	2023-11-14 17:57:53+00	\N	2024-09-25 14:49:58.209927+00	\N
630	2324	Consider starting node with root privileges	{T0-node}	t	f	\N	11	2023-11-14 14:58:20+00	\N	2024-09-25 14:49:58.209927+00	\N
631	2323	Drop unnecessary privileges in node	{T0-node,C1-mentor,I1-security}	t	f	\N	11	2023-11-14 14:57:22+00	\N	2024-09-25 14:49:58.209927+00	\N
632	2301	Create a Dockerfile that is able to build and run Substrate	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-11-13 19:33:51+00	\N	2024-09-25 14:49:58.209927+00	\N
633	2279	[Parachain] Add polkadot-parachain binary to debian packages	{I5-enhancement,T9-cumulus}	t	f	\N	11	2023-11-11 07:21:40+00	\N	2024-09-25 14:49:58.209927+00	\N
634	2278	Upgrade `feeless_if` syntax to use check-pointed data	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-11-11 05:41:38+00	\N	2024-09-25 14:49:58.209927+00	\N
635	2272	Run existing fuzzers in the CI	{T10-tests}	t	f	\N	11	2023-11-10 14:43:53+00	\N	2024-09-25 14:49:58.209927+00	\N
636	2257	Reputation updates are handled inefficiently	{I9-optimisation}	t	f	\N	11	2023-11-09 18:19:50+00	\N	2024-09-25 14:49:58.209927+00	\N
637	2245	[remote-externalities] Batch calls scraping child-tree data	{C1-mentor,I5-enhancement,D1-medium}	t	f	\N	11	2023-11-09 10:09:18+00	\N	2024-09-25 14:49:58.209927+00	\N
638	2240	More specific errors for `decrease_balance`	{C1-mentor,I5-enhancement,T1-FRAME,D0-easy}	t	f	\N	11	2023-11-09 05:40:49+00	\N	2024-09-25 14:49:58.209927+00	\N
639	2238	XCM issue on Kusama	{T6-XCM,T10-tests}	t	f	\N	11	2023-11-09 00:18:48+00	\N	2024-09-25 14:49:58.209927+00	\N
640	2235	Upgrade Kusama runtime in fellowship repo to use async backing	{I10-unconfirmed}	t	f	\N	11	2023-11-08 19:01:56+00	\N	2024-09-25 14:49:58.209927+00	\N
641	2234	Upgrade glutton runtime in fellowship repo	{I10-unconfirmed}	t	f	\N	11	2023-11-08 19:01:00+00	\N	2024-09-25 14:49:58.209927+00	\N
642	2220	Write more warp syncing Zombienet tests	{T10-tests}	t	f	\N	11	2023-11-08 09:31:11+00	\N	2024-09-25 14:49:58.209927+00	\N
643	2218	Write more tests for `validate_block`	{T10-tests}	t	f	\N	11	2023-11-08 09:09:44+00	\N	2024-09-25 14:49:58.209927+00	\N
644	2210	Credits system	{A2-stale}	t	f	\N	11	2023-11-07 17:50:36+00	\N	2024-09-25 14:49:58.209927+00	\N
645	2203	Improve/Refactor Cumulus CLI	{T0-node,I3-annoyance,T9-cumulus}	t	f	\N	11	2023-11-07 13:56:19+00	\N	2024-09-25 14:49:58.209927+00	\N
646	2200	Figure out bounds and configs for MB staking/EPM	{}	t	f	\N	11	2023-11-07 12:56:56+00	\N	2024-09-25 14:49:58.209927+00	\N
647	2199	PoV-friendly Election Provider Multi Block (iter 1)	{T1-FRAME,T14-system_parachains}	t	f	\N	11	2023-11-07 12:45:04+00	\N	2024-09-25 14:49:58.209927+00	\N
648	2195	PVF worker: refactor worker/job errors	{T0-node}	t	f	\N	11	2023-11-07 12:07:19+00	\N	2024-09-25 14:49:58.209927+00	\N
649	2186	refactor polkadot-runtime-common	{C1-mentor,I4-refactor,D2-substantial}	t	f	\N	11	2023-11-07 00:17:44+00	\N	2024-09-25 14:49:58.209927+00	\N
650	2169	XCM Config Defaults	{T6-XCM}	t	f	\N	11	2023-11-06 10:00:14+00	\N	2024-09-25 14:49:58.209927+00	\N
651	2164	PVF worker: add security restrictions to child job process with no exceptions	{T0-node,C1-mentor}	t	f	\N	11	2023-11-05 13:49:36+00	\N	2024-09-25 14:49:58.209927+00	\N
652	2149	Backlink to `docs/DEPRECATION_CHECKLIST.md`	{T11-documentation}	t	f	\N	11	2023-11-03 15:38:38+00	\N	2024-09-25 14:49:58.209927+00	\N
653	2141	Create script to refactor benchmarks v1 to v2	{I9-optimisation,T10-tests,T12-benchmarks}	t	f	\N	11	2023-11-02 18:49:15+00	\N	2024-09-25 14:49:58.209927+00	\N
654	2134	Set up sensible limits for PVF execution and preparation timeouts	{I9-optimisation}	t	f	\N	11	2023-11-02 10:57:39+00	\N	2024-09-25 14:49:58.209927+00	\N
655	2126	Have all the special storage keys in a single place	{C1-mentor,I4-refactor,D1-medium}	t	f	\N	11	2023-11-01 22:06:44+00	\N	2024-09-25 14:49:58.209927+00	\N
656	2124	Make XCM Executor Config composable	{T6-XCM}	t	f	\N	11	2023-11-01 16:14:50+00	\N	2024-09-25 14:49:58.209927+00	\N
657	2116	Get rid off `parachain-info`	{I4-refactor}	t	f	\N	11	2023-11-01 12:53:57+00	\N	2024-09-25 14:49:58.209927+00	\N
658	2108	Improved TryState and TryOnRuntimeUpgrade runtime api parameters	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-11-01 01:45:18+00	\N	2024-09-25 14:49:58.209927+00	\N
659	2105	opentracing support	{I5-enhancement}	t	f	\N	11	2023-10-31 17:10:37+00	\N	2024-09-25 14:49:58.209927+00	\N
660	2101	Remove `sp_std`	{I4-refactor,D0-easy}	t	f	\N	11	2023-10-31 12:41:15+00	\N	2024-09-25 14:49:58.209927+00	\N
661	2096	Remote externalities download slows down at the end	{C1-mentor,T1-FRAME,T10-tests,D0-easy}	t	f	\N	11	2023-10-31 11:01:49+00	\N	2024-09-25 14:49:58.209927+00	\N
662	2094	Blocks downloaded from peers undergoing reorg are treated as extending canonical chain and fail to import	{I2-bug}	t	f	\N	11	2023-10-31 10:19:15+00	\N	2024-09-25 14:49:58.209927+00	\N
663	2082	pallet-xcm: waive transport fees based on `XcmConfig`	{T6-XCM,C1-mentor,I5-enhancement,C2-good-first-issue}	t	f	\N	11	2023-10-30 11:43:51+00	\N	2024-09-25 14:49:58.209927+00	\N
664	2081	Unify imports at the top of a file	{I4-refactor}	t	f	\N	11	2023-10-30 11:17:15+00	\N	2024-09-25 14:49:58.209927+00	\N
665	2078	Investigate bandwidth usage with default `--max-parallel-downloads`	{}	t	f	\N	11	2023-10-30 09:04:41+00	\N	2024-09-25 14:49:58.209927+00	\N
666	2076	Update Substrate docs to cover latest changes.	{T11-documentation}	t	f	\N	11	2023-10-29 19:43:24+00	\N	2024-09-25 14:49:58.209927+00	\N
668	2057	Add fast westend runtimes to paritypr/polkadot-debug	{I10-unconfirmed}	t	f	\N	11	2023-10-27 10:13:47+00	\N	2024-09-25 14:49:58.209927+00	\N
669	2047	NumberOrHex can serialize JSON values that are incompatible with JavaScript	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-10-26 15:51:20+00	\N	2024-09-25 14:49:58.209927+00	\N
670	2037	Fix erroneously double incremented and decremented consumers	{C1-mentor,T1-FRAME}	t	f	\N	11	2023-10-26 03:10:54+00	\N	2024-09-25 14:49:58.209927+00	\N
671	2028	Unify `Hash` and `Bounded`	{T1-FRAME}	t	f	\N	11	2023-10-25 13:12:02+00	\N	2024-09-25 14:49:58.209927+00	\N
672	2015	[FRAME] Enum `UpgradeCheckSelect` should be a bit flag	{C1-mentor,I4-refactor,T1-FRAME,D0-easy}	t	f	\N	11	2023-10-24 19:04:27+00	\N	2024-09-25 14:49:58.209927+00	\N
673	2014	Replace usage of unchecked sp-arithmetic calls with checked versions	{I10-unconfirmed}	t	f	\N	11	2023-10-24 16:48:18+00	\N	2024-09-25 14:49:58.209927+00	\N
674	2000	[FRAME] Try to calculate `MaxHolds`/`MxFreezes` automatically	{T1-FRAME}	t	f	\N	11	2023-10-24 09:20:15+00	\N	2024-09-25 14:49:58.209927+00	\N
675	1994	pallet_nfts attributes not cleared after burning the nft	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-10-23 18:45:28+00	\N	2024-09-25 14:49:58.209927+00	\N
676	1989	`storage_changes_notification_stream` is not properly documented	{I10-unconfirmed}	t	f	\N	11	2023-10-23 13:21:23+00	\N	2024-09-25 14:49:58.209927+00	\N
677	1981	PR13702 [Contracts] Overflowing bounded DeletionQueue	{I10-unconfirmed}	t	f	\N	11	2023-10-23 09:07:10+00	\N	2024-09-25 14:49:58.209927+00	\N
678	1980	PR14079 Contracts Add deposit for dependencies	{I10-unconfirmed}	t	f	\N	11	2023-10-23 09:05:22+00	\N	2024-09-25 14:49:58.209927+00	\N
679	1975	Move crypto implementations out of sp-core	{I5-enhancement,T13-deprecation}	t	f	\N	11	2023-10-22 22:22:30+00	\N	2024-09-25 14:49:58.209927+00	\N
682	1940	Cleanup bolierplate code when `DisabledValidators` runtime api call is released 	{}	t	f	\N	11	2023-10-19 07:37:43+00	\N	2024-09-25 14:49:58.209927+00	\N
683	1937	`check_inherents` method should be in the `CoreApi`, not the `BlockBuilderApi`.	{}	t	f	\N	11	2023-10-18 23:52:31+00	\N	2024-09-25 14:49:58.209927+00	\N
684	1930	Warp sync doesn't work if the target block is the genesis	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-10-18 13:36:03+00	\N	2024-09-25 14:49:58.209927+00	\N
685	1929	Block announcements are dropped because all per-peer validation slots are occupied	{I2-bug}	t	f	\N	11	2023-10-18 12:33:19+00	\N	2024-09-25 14:49:58.209927+00	\N
686	1915	`ChainSync` requesting the same block multiple times	{I2-bug}	t	f	\N	11	2023-10-17 14:17:53+00	\N	2024-09-25 14:49:58.209927+00	\N
687	1905	Emit New Event with Message Hash and ID on DMP Message Sent	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-10-17 09:42:24+00	\N	2024-09-25 14:49:58.209927+00	\N
688	1902	Local cumulus testing environment with staking-related pallets	{}	t	f	\N	11	2023-10-17 08:02:34+00	\N	2024-09-25 14:49:58.209927+00	\N
689	1890	`impl_runtime_apis! {}`: prevent the use of `Self`	{C1-mentor,T1-FRAME,D1-medium}	t	f	\N	11	2023-10-16 14:55:56+00	\N	2024-09-25 14:49:58.209927+00	\N
690	1872	Increase staking miner rewards and # refunds  	{T8-polkadot}	t	f	\N	11	2023-10-14 17:03:15+00	\N	2024-09-25 14:49:58.209927+00	\N
691	1858	Warning for missing instance type	{T1-FRAME}	t	f	\N	11	2023-10-12 07:05:37+00	\N	2024-09-25 14:49:58.209927+00	\N
692	1829	Elastic Scaling	{}	t	f	\N	11	2023-10-09 11:54:37+00	\N	2024-09-25 14:49:58.209927+00	\N
693	1827	[network/notifications] A remote peer is not backed off when it rejects a substream	{I2-bug}	t	f	\N	11	2023-10-09 09:48:52+00	\N	2024-09-25 14:49:58.209927+00	\N
694	1826	[network/notifications] Connection to a disabled peer with an expired back-off is backed off again	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-10-09 09:42:45+00	\N	2024-09-25 14:49:58.209927+00	\N
695	1825	Implement RFC 8: store parachain bootnodes in the relay chain DHT	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-10-09 09:34:52+00	\N	2024-09-25 14:49:58.209927+00	\N
696	1811	Approval Voting Rewards	{I6-meta}	t	f	\N	11	2023-10-07 15:30:20+00	\N	2024-09-25 14:49:58.209927+00	\N
697	1797	Expose and use claim queue for asynchronous on-demand operability	{}	t	f	\N	11	2023-10-05 10:13:53+00	\N	2024-09-25 14:49:58.209927+00	\N
698	1778	[syncing] Trigger block import by hash instead of number	{}	t	f	\N	11	2023-10-03 11:28:41+00	\N	2024-09-25 14:49:58.209927+00	\N
699	1777	Fix-PR#2157 Incorrect implementation of channel suspending may lead to deadlock or dropping of messages	{I10-unconfirmed}	t	f	\N	11	2023-10-03 10:20:18+00	\N	2024-09-25 14:49:58.209927+00	\N
700	1775	PR#13565 [contracts] Port host functions to Weight V2 and storage deposit limit	{I10-unconfirmed}	t	f	\N	11	2023-10-03 09:40:57+00	\N	2024-09-25 14:49:58.209927+00	\N
701	1773	Console spamming about shutting down services when merely reverting a block	{I2-bug,I3-annoyance,I10-unconfirmed}	t	f	\N	11	2023-10-02 21:23:17+00	\N	2024-09-25 14:49:58.209927+00	\N
702	1759	PVF documentation	{T11-documentation}	t	f	\N	11	2023-09-29 17:41:31+00	\N	2024-09-25 14:49:58.209927+00	\N
703	1738	Remove syncing code from `sc-network-common`	{I4-refactor}	t	f	\N	11	2023-09-28 10:33:34+00	\N	2024-09-25 14:49:58.209927+00	\N
704	1732	Collator using wrong address to connect to Validator	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-09-27 21:53:23+00	\N	2024-09-25 14:49:58.209927+00	\N
705	1716	Reintroduce the check-new-bootnode workflow	{I10-unconfirmed}	t	f	\N	11	2023-09-26 14:30:14+00	\N	2024-09-25 14:49:58.209927+00	\N
706	1710	Improvements to OpenGov delegation UX	{I5-enhancement}	t	f	\N	11	2023-09-26 07:03:09+00	\N	2024-09-25 14:49:58.209927+00	\N
707	1697	Running --help for the relaychain side starts the parachain node.	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-09-25 13:25:24+00	\N	2024-09-25 14:49:58.209927+00	\N
708	1690	Referendum Submission Deposit not Claimable if TimeOut	{I10-unconfirmed}	t	f	\N	11	2023-09-25 08:55:23+00	\N	2024-09-25 14:49:58.209927+00	\N
709	1680	Make `sp_runtime` reexport private in `frame_support`	{T1-FRAME}	t	f	\N	11	2023-09-22 15:40:36+00	\N	2024-09-25 14:49:58.209927+00	\N
710	1679	Provide an interface for user-defined extensions	{I5-enhancement}	t	f	\N	11	2023-09-22 14:50:51+00	\N	2024-09-25 14:49:58.209927+00	\N
711	1669	Unable to restore network using export/import blocks - finality is lagging	{I2-bug,I10-unconfirmed}	t	f	\N	11	2023-09-21 17:11:30+00	\N	2024-09-25 14:49:58.209927+00	\N
712	1662	statemine archive node need large amount of memory during startup and the synchronization speed is too slow.	{I2-bug}	t	f	\N	11	2023-09-21 11:24:07+00	\N	2024-09-25 14:49:58.209927+00	\N
713	1632	docs: Streamline pallet documentation exposed in the metadata	{I5-enhancement,T11-documentation}	t	f	\N	11	2023-09-19 11:10:11+00	\N	2024-09-25 14:49:58.209927+00	\N
714	1630	Mismatch between number of voters in JS apps and w3f watcher	{I10-unconfirmed}	t	f	\N	11	2023-09-19 08:47:35+00	\N	2024-09-25 14:49:58.209927+00	\N
715	1629	XCM Retry Queue	{T6-XCM,I5-enhancement}	t	f	\N	11	2023-09-19 04:42:20+00	\N	2024-09-25 14:49:58.209927+00	\N
716	1628	Limit resource usage of state_call	{T0-node,I5-enhancement,T4-runtime_API,D2-substantial}	t	f	\N	11	2023-09-19 04:39:56+00	\N	2024-09-25 14:49:58.209927+00	\N
717	1626	Ability to charge extra fee for operational transaction to prevent spam 	{C1-mentor,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2023-09-19 04:37:45+00	\N	2024-09-25 14:49:58.209927+00	\N
718	1625	Requires a deposit for setting session keys	{C1-mentor,D0-easy}	t	f	\N	11	2023-09-19 04:36:21+00	\N	2024-09-25 14:49:58.209927+00	\N
719	1623	conviction-voting: allow a single account to cast multiple different votes	{}	t	f	\N	11	2023-09-19 04:32:47+00	\N	2024-09-25 14:49:58.209927+00	\N
720	1622	A way to enforce transaction order in a block	{T1-FRAME}	t	f	\N	11	2023-09-19 04:25:20+00	\N	2024-09-25 14:49:58.209927+00	\N
722	1610	Tracker issue to set progressive deposit for EPM signed submissions in Polkadot	{T8-polkadot}	t	f	\N	11	2023-09-18 09:20:58+00	\N	2024-09-25 14:49:58.209927+00	\N
723	1605	Accounts delegating voting should vote Abstain when delegated account votes Abstain	{I10-unconfirmed}	t	f	\N	11	2023-09-18 02:48:05+00	\N	2024-09-25 14:49:58.209927+00	\N
724	1601	CI: Test Landlock on various kernels with UML	{T10-tests}	t	f	\N	11	2023-09-17 09:04:20+00	\N	2024-09-25 14:49:58.209927+00	\N
725	1597	Improve timeout-based tests	{}	t	f	\N	11	2023-09-16 13:45:59+00	\N	2024-09-25 14:49:58.209927+00	\N
726	1590	Zombienet testing for validator disabling	{}	t	f	\N	11	2023-09-15 15:17:25+00	\N	2024-09-25 14:49:58.209927+00	\N
727	1588	overseer: better accuracy for channel len measurements	{I5-enhancement}	t	f	\N	11	2023-09-15 14:30:16+00	\N	2024-09-25 14:49:58.209927+00	\N
728	1587	Some bounded channels are not bounded	{I2-bug}	t	f	\N	11	2023-09-15 14:16:38+00	\N	2024-09-25 14:49:58.209927+00	\N
729	1576	PVF: Refactor argument passing	{I4-refactor}	t	f	\N	11	2023-09-14 16:21:09+00	\N	2024-09-25 14:49:58.209927+00	\N
730	1570	Add APIs for block pruning manually	{T0-node}	t	f	\N	11	2023-09-14 14:11:40+00	\N	2024-09-25 14:49:58.209927+00	\N
731	1569	Frame: Remove old `Currency` based code from Preimage Pallet	{T1-FRAME}	t	f	\N	11	2023-09-14 14:00:21+00	\N	2024-09-25 14:49:58.209927+00	\N
732	1559	Consider parameterise the `era_payout` formula	{I5-enhancement}	t	f	\N	11	2023-09-14 08:57:24+00	\N	2024-09-25 14:49:58.209927+00	\N
733	1533	Support conditional compilation in decl_runtime_apis and frame_support::pallet	{}	t	f	\N	11	2023-09-13 07:45:55+00	\N	2024-09-25 14:49:58.209927+00	\N
734	1532	[rpc] we need the rpc to subscribe or filter the event for substrate chain.	{}	t	f	\N	11	2023-09-13 04:09:25+00	\N	2024-09-25 14:49:58.209927+00	\N
735	1525	Improve `validators_buffer` behavior in collator protocol	{I3-annoyance}	t	f	\N	11	2023-09-12 21:24:16+00	\N	2024-09-25 14:49:58.209927+00	\N
736	1523	[FRAME] Purge invalid `Balances::Locks` items	{T1-FRAME}	t	f	\N	11	2023-09-12 17:13:00+00	\N	2024-09-25 14:49:58.209927+00	\N
737	1516	[RPC-Spec-V2] overarching: Implement RPC Spec V2 	{I5-enhancement}	t	f	\N	11	2023-09-12 11:53:15+00	\N	2024-09-25 14:49:58.209927+00	\N
738	1499	libp2p may be falsely re-establishing connections for reserved peers, or dropping messages	{I2-bug}	t	f	\N	11	2023-09-12 01:02:02+00	\N	2024-09-25 14:49:58.209927+00	\N
739	1491	Crates missing licenses in Cargo.toml	{}	t	f	\N	11	2023-09-11 11:16:22+00	\N	2024-09-25 14:49:58.209927+00	\N
740	1487	On-demand Cumulus Integration	{I6-meta}	t	f	\N	11	2023-09-11 08:47:42+00	\N	2024-09-25 14:49:58.209927+00	\N
741	1481	Add Dispatchable Interface for Staking's `reward_by_ids` and `report_offence`	{I5-enhancement,T2-pallets}	t	f	\N	11	2023-09-09 17:08:41+00	\N	2024-09-25 14:49:58.209927+00	\N
742	1467	Add test suite for lookahead collator	{T10-tests}	t	f	\N	11	2023-09-08 14:33:09+00	\N	2024-09-25 14:49:58.209927+00	\N
743	1453	`CheckNonce` should refuse transactions signed by accounts with no providers	{I10-unconfirmed}	t	f	\N	11	2023-09-07 17:33:33+00	\N	2024-09-25 14:49:58.209927+00	\N
744	1443	Improve the testing framework of `sc-network`	{T10-tests,D1-medium}	t	f	\N	11	2023-09-07 09:37:19+00	\N	2024-09-25 14:49:58.209927+00	\N
745	1434	High Level PVF Nondeterminism	{I10-unconfirmed}	t	f	\N	11	2023-09-06 18:16:49+00	\N	2024-09-25 14:49:58.209927+00	\N
746	1431	XCMP-Queue: check suspension logic when setting new thresholds	{T6-XCM,T1-FRAME}	t	f	\N	11	2023-09-06 15:27:27+00	\N	2024-09-25 14:49:58.209927+00	\N
747	1423	`examples` directory to be a proper examples directory instead of its own crate	{T1-FRAME}	t	f	\N	11	2023-09-06 12:39:14+00	\N	2024-09-25 14:49:58.209927+00	\N
748	1404	Proxy deposit vanished	{I10-unconfirmed}	t	f	\N	11	2023-09-05 10:47:45+00	\N	2024-09-25 14:49:58.209927+00	\N
749	1389	[xcm-emulator] Restructure Parachains Integration Tests	{T6-XCM}	t	f	\N	11	2023-09-04 10:53:37+00	\N	2024-09-25 14:49:58.209927+00	\N
750	1388	[xcm-emulator] Parachain's block execution should process only its messages	{T6-XCM}	t	f	\N	11	2023-09-04 10:07:03+00	\N	2024-09-25 14:49:58.209927+00	\N
751	1385	[xcm-emulator] Add Documentation and examples	{T6-XCM}	t	f	\N	11	2023-09-04 09:59:59+00	\N	2024-09-25 14:49:58.209927+00	\N
752	1384	[xcm-emulator] Add `on_initialize` and `on_finalize` hooks	{T6-XCM}	t	f	\N	11	2023-09-04 09:54:55+00	\N	2024-09-25 14:49:58.209927+00	\N
753	1383	[xcm-emulator] Allow Chains and Network imports from `integration-tests-common` crate	{T6-XCM}	t	f	\N	11	2023-09-04 09:51:25+00	\N	2024-09-25 14:49:58.209927+00	\N
754	1374	Use stable rustfmt	{I3-annoyance}	t	f	\N	11	2023-09-03 15:47:51+00	\N	2024-09-25 14:49:58.209927+00	\N
755	1359	Ensure candidate validation, disputes and approvals work, even if the candidate's relay parent state was pruned.	{T10-tests}	t	f	\N	11	2023-09-01 18:27:10+00	\N	2024-09-25 14:49:58.209927+00	\N
756	1354	Avoid including `substrate/bin/node/cli/src/cli.rs` in `build.rs`	{I10-unconfirmed}	t	f	\N	11	2023-09-01 15:09:17+00	\N	2024-09-25 14:49:58.209927+00	\N
757	1353	All nodes in `major sync`, all nodes being stuck	{I10-unconfirmed}	t	f	\N	11	2023-09-01 13:04:01+00	\N	2024-09-25 14:49:58.209927+00	\N
758	1351	[FRAME] Move mocks adjacent to their traits	{}	t	f	\N	11	2023-09-01 12:23:27+00	\N	2024-09-25 14:49:58.209927+00	\N
759	1345	Mixnet integration	{I10-unconfirmed}	t	f	\N	11	2023-08-31 23:28:30+00	\N	2024-09-25 14:49:58.209927+00	\N
760	1332	Consider restricting cumulus access to unnecessary runtime APIs	{}	t	f	\N	11	2023-08-31 11:17:35+00	\N	2024-09-25 14:49:58.209927+00	\N
761	1318	Ensure separation of dependencies in Substrate, Cumulus, Polkadot is maintained	{I5-enhancement,D0-easy}	t	f	\N	11	2023-08-30 17:56:53+00	\N	2024-09-25 14:49:58.209927+00	\N
762	1312	Instant on-demand orders	{}	t	f	\N	11	2023-08-30 14:56:44+00	\N	2024-09-25 14:49:58.209927+00	\N
763	1302	sc_consensus_slots::check_equivocation is not guaranteed to catch equivocation	{}	t	f	\N	11	2023-08-30 10:23:55+00	\N	2024-09-25 14:49:58.209927+00	\N
764	1274	GHW: Runtime diffing	{}	t	f	\N	11	2023-08-29 15:57:30+00	\N	2024-09-25 14:49:58.209927+00	\N
765	1270	GHW - burnin notifications	{}	t	f	\N	11	2023-08-29 15:41:41+00	\N	2024-09-25 14:49:58.209927+00	\N
766	1269	Crates.io publishing as Github Workflow	{}	t	f	\N	11	2023-08-29 15:33:44+00	\N	2024-09-25 14:49:58.209927+00	\N
767	1260	Triage `.md` files	{T11-documentation}	t	f	\N	11	2023-08-29 13:02:41+00	\N	2024-09-25 14:49:58.209927+00	\N
768	1258	XCM: Allow decode length upper bound to be parameterisable	{T6-XCM}	t	f	\N	11	2023-08-29 12:32:17+00	\N	2024-09-25 14:49:58.209927+00	\N
769	1232	Block response size check is not correct	{}	t	f	\N	11	2023-08-29 00:38:49+00	\N	2024-09-25 14:49:58.209927+00	\N
770	1228	Improve dispute participation robustness by exposing upcoming session information	{}	t	f	\N	11	2023-08-28 17:12:54+00	\N	2024-09-25 14:49:58.209927+00	\N
771	1213	Break down `sp_runtime` into smaller pieces	{T1-FRAME}	t	f	\N	11	2023-08-28 13:00:20+00	\N	2024-09-25 14:49:58.209927+00	\N
772	1202	Improve transaction handling for Parachains	{I5-enhancement}	t	f	\N	11	2023-08-28 08:42:56+00	\N	2024-09-25 14:49:58.209927+00	\N
773	1195	Refactor `Payee` and `RewardDestination` for split and controller removal	{I5-enhancement}	t	f	\N	11	2023-08-28 02:06:01+00	\N	2024-09-25 14:49:58.209927+00	\N
774	1175	Revive Stale bot	{}	t	f	\N	11	2023-08-25 15:57:18+00	\N	2024-09-25 14:49:58.209927+00	\N
775	1168	Asset conversion quote A->B can't be done in one call	{T2-pallets,T4-runtime_API}	t	f	\N	11	2023-08-25 14:13:10+00	\N	2024-09-25 14:49:58.209927+00	\N
776	1160	Cleanup: remove duplicate files	{}	t	f	\N	11	2023-08-25 12:25:34+00	\N	2024-09-25 14:49:58.209927+00	\N
777	1158	Check all .toml files for updated repo information	{}	t	f	\N	11	2023-08-25 11:54:18+00	\N	2024-09-25 14:49:58.209927+00	\N
778	1154	Malus worker and executor binary name collision	{}	t	f	\N	11	2023-08-25 11:09:24+00	\N	2024-09-25 14:49:58.209927+00	\N
779	1147	sync: Invalid justification provided 	{I2-bug}	t	f	\N	11	2023-08-25 09:41:10+00	\N	2024-09-25 14:49:58.209927+00	\N
780	492	Re-evaluate Clippy lints	{D0-easy}	t	f	\N	11	2023-08-24 14:40:40+00	\N	2024-09-25 14:49:58.209927+00	\N
781	123	Support dry-running in `TestExternalities`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-08-24 09:28:26+00	\N	2024-09-25 14:49:58.209927+00	\N
782	491	[Meta] Moving Staking off the Relay Chain	{I6-meta}	t	f	\N	11	2023-08-23 19:45:57+00	\N	2024-09-25 14:49:58.209927+00	\N
783	125	[FRAME] Re-normalization migration for `pallet-conviction-voting`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-08-22 11:21:41+00	\N	2024-09-25 14:49:58.209927+00	\N
784	127	Break down `frame_support` into smaller pieces	{T1-FRAME}	t	f	\N	11	2023-08-21 08:43:48+00	\N	2024-09-25 14:49:58.209927+00	\N
785	128	Create new `pallets` folder	{T1-FRAME,T2-pallets}	t	f	\N	11	2023-08-21 08:42:51+00	\N	2024-09-25 14:49:58.209927+00	\N
786	991	RFC: everything in rust docs	{I5-enhancement,I6-meta,T11-documentation}	t	f	\N	11	2023-08-18 20:13:08+00	\N	2024-09-25 14:49:58.209927+00	\N
787	575	`availability-recovery`: fetch available data from approval checkers	{I9-optimisation}	t	f	\N	11	2023-08-18 14:53:08+00	\N	2024-09-25 14:49:58.209927+00	\N
788	1127	[xcm-emulator] Investigate (and fix) `assert_xcm_pallet_sent` 	{T6-XCM}	t	f	\N	11	2023-08-18 11:26:23+00	\N	2024-09-25 14:49:58.209927+00	\N
789	578	Fix past session slashing Zombienet test	{I2-bug}	t	f	\N	11	2023-08-16 16:48:36+00	\N	2024-09-25 14:49:58.209927+00	\N
790	132	Auto-generated docs prevent `missing_docs` lint	{T1-FRAME}	t	f	\N	11	2023-08-16 12:37:55+00	\N	2024-09-25 14:49:58.209927+00	\N
791	133	Vision: Repository reorganization	{T1-FRAME}	t	f	\N	11	2023-08-16 11:31:31+00	\N	2024-09-25 14:49:58.209927+00	\N
792	100	Simplify `IsForeignConcreteAsset` Implementation	{}	t	f	\N	11	2023-08-14 12:38:23+00	\N	2024-09-25 14:49:58.209927+00	\N
793	134	Fix all broken links	{T1-FRAME,T11-documentation}	t	f	\N	11	2023-08-14 10:21:20+00	\N	2024-09-25 14:49:58.209927+00	\N
794	580	Update `availability_timeout_predicate` and `_availability_period` config parameter docs	{}	t	f	\N	11	2023-08-11 14:47:27+00	\N	2024-09-25 14:49:58.209927+00	\N
795	1118	BEEFY: add BEEFY-specific warp proofs so we can warp sync when using BEEFY	{}	t	f	\N	11	2023-08-11 11:40:57+00	\N	2024-09-25 14:49:58.209927+00	\N
796	135	`pallet_nfts` Missing `force_` methods, public`do_`	{I5-enhancement,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-08-10 23:21:28+00	\N	2024-09-25 14:49:58.209927+00	\N
797	402	Move `StakingLedger` struct definition and implementation	{C1-mentor,D0-easy,C2-good-first-issue}	t	f	\N	11	2023-08-10 19:45:36+00	\N	2024-09-25 14:49:58.209927+00	\N
798	581	PVF: Document code structure	{T11-documentation}	t	f	\N	11	2023-08-09 13:20:24+00	\N	2024-09-25 14:49:58.209927+00	\N
799	582	Polkadot v1.0.0 Dockerfile build fails	{}	t	f	\N	11	2023-08-09 06:05:42+00	\N	2024-09-25 14:49:58.209927+00	\N
800	137	Support using customize extensions in runtime benchmarking	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-08-08 12:31:25+00	\N	2024-09-25 14:49:58.209927+00	\N
801	139	`is_full` without decoding whole collection	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-08-07 15:51:51+00	\N	2024-09-25 14:49:58.209927+00	\N
802	404	Consider simplifying the `ElectionBounds` logic and `ElectionBoundsBuilder` API	{I5-enhancement}	t	f	\N	11	2023-08-06 06:43:32+00	\N	2024-09-25 14:49:58.209927+00	\N
803	140	FRAME: Enforce inherent order from the runtime	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-08-06 02:58:04+00	\N	2024-09-25 14:49:58.209927+00	\N
804	141	`CountedMap` with an enforced `MaxValue`	{T1-FRAME}	t	f	\N	11	2023-08-05 20:26:44+00	\N	2024-09-25 14:49:58.209927+00	\N
805	585	Crates need descriptions	{}	t	f	\N	11	2023-08-05 04:57:35+00	\N	2024-09-25 14:49:58.209927+00	\N
806	142	[FRAME] Cleanup storage 'generator' types 	{I4-refactor,T1-FRAME,D1-medium}	t	f	\N	11	2023-08-04 11:09:15+00	\N	2024-09-25 14:49:58.209927+00	\N
807	586	Consider refactoring subsystem initialization in overseer	{I4-refactor}	t	f	\N	11	2023-08-03 08:46:37+00	\N	2024-09-25 14:49:58.209927+00	\N
808	588	Remove secrets that are no secrets	{}	t	f	\N	11	2023-08-02 14:58:36+00	\N	2024-09-25 14:49:58.209927+00	\N
809	405	Revisit staking ledger stake calculations and consider refactor to saturating arithmetic	{C1-mentor}	t	f	\N	11	2023-08-02 11:06:35+00	\N	2024-09-25 14:49:58.209927+00	\N
810	589	High rate of dial failures / peers not connected for request/response on Versi	{I2-bug}	t	f	\N	11	2023-08-01 03:59:16+00	\N	2024-09-25 14:49:58.209927+00	\N
811	590	Improve file structure	{C1-mentor,I4-refactor,D0-easy,C2-good-first-issue}	t	f	\N	11	2023-08-01 03:12:42+00	\N	2024-09-25 14:49:58.209927+00	\N
812	406	Rethink `VoteWeight` and `CurrencyToVote` trait in staking	{I5-enhancement}	t	f	\N	11	2023-07-28 21:43:33+00	\N	2024-09-25 14:49:58.209927+00	\N
813	591	Improvements to childbounties IDs	{}	t	f	\N	11	2023-07-28 12:50:33+00	\N	2024-09-25 14:49:58.209927+00	\N
814	3609	Substrate BIP-39 generate different seeds between Polkadot-API and Subkey	{I10-unconfirmed}	t	f	\N	11	2023-07-27 23:15:18+00	\N	2024-09-25 14:49:58.209927+00	\N
815	145	pallet-fast-unstake fails to compile during publish	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-07-27 21:17:54+00	\N	2024-09-25 14:49:58.209927+00	\N
816	494	[network] Delay peer outbound connection in `ProtocolController` if the dial failed	{I3-annoyance}	t	f	\N	11	2023-07-27 12:33:31+00	\N	2024-09-25 14:49:58.209927+00	\N
817	592	Discussion: PVF Compilation(Interpretation) time testing	{}	t	f	\N	11	2023-07-26 08:33:55+00	\N	2024-09-25 14:49:58.209927+00	\N
818	495	`PeerIdentify` must not add a remote address if we don't belong to the same chain	{I2-bug,D0-easy}	t	f	\N	11	2023-07-25 13:46:47+00	\N	2024-09-25 14:49:58.209927+00	\N
819	496	Make min peers to start warp sync configurable	{I5-enhancement}	t	f	\N	11	2023-07-25 13:27:50+00	\N	2024-09-25 14:49:58.209927+00	\N
820	149	Prevent storage item reads/writes at compile time by types that are not whitelisted	{I5-enhancement,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-07-24 14:22:20+00	\N	2024-09-25 14:49:58.209927+00	\N
821	593	Approval votes by hash inversion vs faster assignment VRFs	{}	t	f	\N	11	2023-07-24 14:12:15+00	\N	2024-09-25 14:49:58.209927+00	\N
822	497	Test `sync::syncs_header_only_forks` is flaky in `sc-network-test`	{T10-tests}	t	f	\N	11	2023-07-24 14:10:04+00	\N	2024-09-25 14:49:58.209927+00	\N
823	151	benchmarking: Provide default `RemarkBuilder` impl for `SignedExtensions`	{I4-refactor,I5-enhancement,T1-FRAME}	t	f	\N	11	2023-07-22 15:48:12+00	\N	2024-09-25 14:49:58.209927+00	\N
824	152	Automatic weight sanity checker	{C1-mentor,I5-enhancement,T1-FRAME}	t	f	\N	11	2023-07-21 18:14:29+00	\N	2024-09-25 14:49:58.209927+00	\N
825	478	`messageQueue` not showing Error when `success` is no	{T6-XCM,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-07-21 13:51:31+00	\N	2024-09-25 14:49:58.209927+00	\N
826	1129	[asset-conversion] Runtime api AssetConversionApi  for AssetHubs uses `Box<MultiLocation>` for public interface	{T6-XCM}	t	f	\N	11	2023-07-21 12:42:30+00	\N	2024-09-25 14:49:58.209927+00	\N
827	1119	BEEFY: Support protocol live-update	{}	t	f	\N	11	2023-07-21 10:26:48+00	\N	2024-09-25 14:49:58.209927+00	\N
828	498	Addresses getting removed from Kademlia after a disconnection	{I2-bug,I3-annoyance}	t	f	\N	11	2023-07-20 13:37:07+00	\N	2024-09-25 14:49:58.209927+00	\N
829	594	Polkadot v1.0.0-cumulus Release checklist	{}	t	f	\N	11	2023-07-20 08:59:30+00	\N	2024-09-25 14:49:58.209927+00	\N
830	1130	[asset-hubs] Investigate usage of MultiLocation vs VersionedMultiLocation	{T6-XCM}	t	f	\N	11	2023-07-19 20:42:24+00	\N	2024-09-25 14:49:58.209927+00	\N
831	595	Automatically test the systemd service on CI	{}	t	f	\N	11	2023-07-19 15:44:06+00	\N	2024-09-25 14:49:58.209927+00	\N
832	101	Allow Asset Conversion Subscriptions	{I5-enhancement}	t	f	\N	11	2023-07-18 17:34:48+00	\N	2024-09-25 14:49:58.209927+00	\N
833	597	totalIssuance decreasing on failed XCM message	{T6-XCM}	t	f	\N	11	2023-07-17 13:31:11+00	\N	2024-09-25 14:49:58.209927+00	\N
834	153	[Deprecation] `WeightMeter` function renaming	{T1-FRAME,T13-deprecation}	t	f	\N	11	2023-07-17 13:15:09+00	\N	2024-09-25 14:49:58.209927+00	\N
835	154	Add `OrdNoBound` and `PartialOrdNoBound` macros	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-07-14 09:44:20+00	\N	2024-09-25 14:49:58.209927+00	\N
836	407	[NPoS] Unify staking functions across staking pallet and nomination pallet	{I10-unconfirmed}	t	f	\N	11	2023-07-12 11:01:30+00	\N	2024-09-25 14:49:58.209927+00	\N
837	601	Rename ParaId and para_id	{I4-refactor,T11-documentation}	t	f	\N	11	2023-07-10 12:59:51+00	\N	2024-09-25 14:49:58.209927+00	\N
838	408	[NPoS] Staking: Users can delegate their fund to a target which can nominate on their behalf.	{I5-enhancement}	t	f	\N	11	2023-07-08 15:51:18+00	\N	2024-09-25 14:49:58.209927+00	\N
839	156	Mocked `fungibles::*` traits	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-07-07 12:50:54+00	\N	2024-09-25 14:49:58.209927+00	\N
840	602	dispute-coordinator possible bug: `handle_import_statements` considers our own votes invalid!	{I2-bug}	t	f	\N	11	2023-07-06 15:17:27+00	\N	2024-09-25 14:49:58.209927+00	\N
841	157	MQ pallet: Clear empty books	{T1-FRAME}	t	f	\N	11	2023-07-06 15:01:19+00	\N	2024-09-25 14:49:58.209927+00	\N
842	85	Temporal Restrictions for Proxies	{I5-enhancement}	t	f	\N	11	2023-07-06 11:08:20+00	\N	2024-09-25 14:49:58.209927+00	\N
843	409	Permissionless nomination pool commission claiming	{}	t	f	\N	11	2023-07-05 08:36:50+00	\N	2024-09-25 14:49:58.209927+00	\N
844	605	availability-recovery optimizations	{}	t	f	\N	11	2023-07-04 09:53:31+00	\N	2024-09-25 14:49:58.209927+00	\N
845	1135	Update docs and scripts to not using nightly	{T11-documentation}	t	f	\N	11	2023-07-04 04:24:42+00	\N	2024-09-25 14:49:58.209927+00	\N
846	1121	BEEFY: disaster-recovery: losing validator keys	{T15-bridges}	t	f	\N	11	2023-07-03 15:34:10+00	\N	2024-09-25 14:49:58.209927+00	\N
847	480	Buffer Downward Messages for Parachains during MBMs	{}	t	f	\N	11	2023-07-02 15:31:51+00	\N	2024-09-25 14:49:58.209927+00	\N
848	606	Pubsub mechanism for Parachains	{T6-XCM,I5-enhancement}	t	f	\N	11	2023-06-30 10:14:32+00	\N	2024-09-25 14:49:58.209927+00	\N
849	607	Idea: Core Groups	{I6-meta}	t	f	\N	11	2023-06-29 14:00:36+00	\N	2024-09-25 14:49:58.209927+00	\N
850	608	Simplifying Token Unlocking Process for Referenda	{}	t	f	\N	11	2023-06-29 12:08:17+00	\N	2024-09-25 14:49:58.209927+00	\N
851	3	Decrease RAM usage on startup	{}	t	f	\N	11	2023-06-27 11:25:39+00	\N	2024-09-25 14:49:58.209927+00	\N
852	104	Configure Polkadot <> Kusama Bridge to Use Asset Conversion to Buy Execution	{I5-enhancement,T14-system_parachains,T15-bridges}	t	f	\N	11	2023-06-25 11:49:31+00	\N	2024-09-25 14:49:58.209927+00	\N
853	105	`ChargeWeightInFungibles` Should Use Asset Conversion Instead of Default `BalanceToAssetBalance`	{I5-enhancement,T1-FRAME,T14-system_parachains}	t	f	\N	11	2023-06-25 11:47:44+00	\N	2024-09-25 14:49:58.209927+00	\N
854	86	`ChargeAssetTxPayment` Should Handle Fee Withdrawal Better When an Account Does Not Exist in `System`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-06-25 11:44:45+00	\N	2024-09-25 14:49:58.209927+00	\N
855	87	Add Benchmarking/Weights for Signed Extensions	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-06-25 11:33:28+00	\N	2024-09-25 14:49:58.209927+00	\N
856	88	Asset Conversion `LPFee` Should Use a `Per{Something}` Instead of `u32`	{I4-refactor,T1-FRAME}	t	f	\N	11	2023-06-25 11:31:42+00	\N	2024-09-25 14:49:58.209927+00	\N
857	161	Improve pallet-balances 	{T1-FRAME}	t	f	\N	11	2023-06-23 00:44:57+00	\N	2024-09-25 14:49:58.209927+00	\N
858	410	Refactor `Payee` and `RewardDestination` for split and controller removal	{I5-enhancement}	t	f	\N	11	2023-06-22 08:00:45+00	\N	2024-09-25 14:49:58.209927+00	\N
859	499	Customizing SyncingEngine	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-06-21 14:04:00+00	\N	2024-09-25 14:49:58.209927+00	\N
860	162	`frame::benchmarking`: Support custom `Config` trait	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-06-21 12:03:14+00	\N	2024-09-25 14:49:58.209927+00	\N
861	482	Ensure all runtimes are using the correct weight files	{T1-FRAME}	t	f	\N	11	2023-06-21 11:31:43+00	\N	2024-09-25 14:49:58.209927+00	\N
862	163	Allow for custom clippy lints for FRAME pallets	{I5-enhancement,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-06-21 09:32:24+00	\N	2024-09-25 14:49:58.209927+00	\N
863	500	Fix disconnection of reserved peers when they are banned	{I3-annoyance}	t	f	\N	11	2023-06-16 15:46:54+00	\N	2024-09-25 14:49:58.209927+00	\N
864	610	[XCM] Move XCM into its own repo	{T6-XCM}	t	f	\N	11	2023-06-15 18:43:05+00	\N	2024-09-25 14:49:58.209927+00	\N
865	612	Support batch peer reporting in NetworkService	{}	t	f	\N	11	2023-06-15 13:54:24+00	\N	2024-09-25 14:49:58.209927+00	\N
866	164	Move some inherent logic outside of `construct_runtime`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-06-15 11:10:48+00	\N	2024-09-25 14:49:58.209927+00	\N
867	614	Nomination pools payout bug report. 0622 Update: New Findings	{}	t	f	\N	11	2023-06-15 08:37:22+00	\N	2024-09-25 14:49:58.209927+00	\N
868	504	Remove support for legacy `ProtocolId`-based protocol names	{I3-annoyance,D0-easy}	t	f	\N	11	2023-06-13 12:26:28+00	\N	2024-09-25 14:49:58.209927+00	\N
869	165	[FRAME] Static analysis for HDH/ME code	{T1-FRAME}	t	f	\N	11	2023-06-12 11:18:18+00	\N	2024-09-25 14:49:58.209927+00	\N
870	166	fungible traits: improve api docs	{T1-FRAME,T11-documentation}	t	f	\N	11	2023-06-12 10:00:26+00	\N	2024-09-25 14:49:58.209927+00	\N
871	616	Collator Protocol Revamp Draft	{I6-meta}	t	f	\N	11	2023-06-12 09:31:46+00	\N	2024-09-25 14:49:58.209927+00	\N
872	505	Libp2p identify `protocolVersion` should be set to the name of the chain	{}	t	f	\N	11	2023-06-09 07:28:30+00	\N	2024-09-25 14:49:58.209927+00	\N
873	617	Reduce messages size used to communicate between subsystems	{R0-silent}	t	f	\N	11	2023-06-08 12:46:54+00	\N	2024-09-25 14:49:58.209927+00	\N
874	167	Collective pallet - remove `without_storage_info`	{T1-FRAME}	t	f	\N	11	2023-06-08 11:04:02+00	\N	2024-09-25 14:49:58.209927+00	\N
875	168	[Deprecation] Deprecate Gov1 pallets	{I5-enhancement,T1-FRAME,T13-deprecation}	t	f	\N	11	2023-06-07 11:11:37+00	\N	2024-09-25 14:49:58.209927+00	\N
876	4	Persistent State Storage for Improved State Syncing	{I5-enhancement}	t	f	\N	11	2023-06-03 21:30:19+00	\N	2024-09-25 14:49:58.209927+00	\N
877	620	Use Glutton to stress test parachain consensus on Versi	{T10-tests}	t	f	\N	11	2023-06-02 17:11:20+00	\N	2024-09-25 14:49:58.209927+00	\N
878	621	DustRemoval seems to be inconsistent with Total Issuance	{}	t	f	\N	11	2023-06-02 13:43:43+00	\N	2024-09-25 14:49:58.209927+00	\N
879	170	allow conviction for split voting	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-05-31 08:53:11+00	\N	2024-09-25 14:49:58.209927+00	\N
880	5	Vision for cleaner substrate-node's developer-facing interface	{T0-node,T1-FRAME}	t	f	\N	11	2023-05-31 08:42:25+00	\N	2024-09-25 14:49:58.209927+00	\N
881	6	Transaction Pool Dropping Certain Transactions	{I2-bug}	t	f	\N	11	2023-05-26 11:55:22+00	\N	2024-09-25 14:49:58.209927+00	\N
882	171	[FRAME Core] tracking issue for full unleash of `DefaultConfig` for FRAME	{I6-meta,T1-FRAME}	t	f	\N	11	2023-05-26 11:37:20+00	\N	2024-09-25 14:49:58.209927+00	\N
883	71	Ensure parachain blocks are taking the PVF validation memory limit into account	{I5-enhancement}	t	f	\N	11	2023-05-26 08:10:11+00	\N	2024-09-25 14:49:58.209927+00	\N
884	625	Automate placing on demand parachain orders for tests	{}	t	f	\N	11	2023-05-25 11:15:39+00	\N	2024-09-25 14:49:58.209927+00	\N
885	172	Restructure macro-related exports into `private` mods	{T1-FRAME}	t	f	\N	11	2023-05-24 11:58:16+00	\N	2024-09-25 14:49:58.209927+00	\N
886	7	`sc-client-api` is not named correctly	{C1-mentor,I4-refactor,D0-easy}	t	f	\N	11	2023-05-24 07:47:54+00	\N	2024-09-25 14:49:58.209927+00	\N
887	506	Add backpressure to `Notifications` substreams allocation	{}	t	f	\N	11	2023-05-18 12:09:42+00	\N	2024-09-25 14:49:58.209927+00	\N
888	630	Add Zombienet parachain throughput test	{T10-tests}	t	f	\N	11	2023-05-18 08:51:55+00	\N	2024-09-25 14:49:58.209927+00	\N
889	631	Replace Mentions of Parathreads in the Parachain Host Implementers Guide	{T11-documentation}	t	f	\N	11	2023-05-17 11:11:23+00	\N	2024-09-25 14:49:58.209927+00	\N
890	632	Kusama node stop syncing on v0.9.42	{}	t	f	\N	11	2023-05-17 03:39:58+00	\N	2024-09-25 14:49:58.209927+00	\N
891	507	Return peer info instead of `Peerset::debug_info`	{I3-annoyance}	t	f	\N	11	2023-05-16 13:21:22+00	\N	2024-09-25 14:49:58.209927+00	\N
892	633	Fix probabalistic finality soundness	{}	t	f	\N	11	2023-05-15 15:03:47+00	\N	2024-09-25 14:49:58.209927+00	\N
893	634	PVF workers: consider zeroing all process memory	{}	t	f	\N	11	2023-05-15 14:35:45+00	\N	2024-09-25 14:49:58.209927+00	\N
894	635	Slash approval voters on approving invalid blocks - dynamically	{}	t	f	\N	11	2023-05-15 12:45:34+00	\N	2024-09-25 14:49:58.209927+00	\N
895	636	[Feature request] Migrating a paraid to a new "manager" account	{I5-enhancement}	t	f	\N	11	2023-05-15 11:48:55+00	\N	2024-09-25 14:49:58.209927+00	\N
896	637	Run `hardening-check` on generated binaries	{}	t	f	\N	11	2023-05-15 11:45:15+00	\N	2024-09-25 14:49:58.209927+00	\N
897	411	Remove controllers from `stakers` configs.	{}	t	f	\N	11	2023-05-15 04:26:03+00	\N	2024-09-25 14:49:58.209927+00	\N
898	638	PVF worker: explore alternative allocators	{}	t	f	\N	11	2023-05-14 23:12:47+00	\N	2024-09-25 14:49:58.209927+00	\N
899	8	warp sync without download histrocial blocks	{I5-enhancement}	t	f	\N	11	2023-05-10 05:15:28+00	\N	2024-09-25 14:49:58.209927+00	\N
900	640	Better approval voting paramters	{}	t	f	\N	11	2023-05-09 20:43:46+00	\N	2024-09-25 14:49:58.209927+00	\N
901	9	Investigate failing grandpa voter while doing warp sync	{I2-bug}	t	f	\N	11	2023-05-08 15:18:10+00	\N	2024-09-25 14:49:58.209927+00	\N
902	644	Improve XCM debuggability 	{T6-XCM,C1-mentor,I4-refactor,D0-easy,C2-good-first-issue}	t	f	\N	11	2023-05-08 06:25:25+00	\N	2024-09-25 14:49:58.209927+00	\N
903	508	Rethink if we should tolerate a closed inbound `Notifications` substream	{I3-annoyance}	t	f	\N	11	2023-05-08 05:40:23+00	\N	2024-09-25 14:49:58.209927+00	\N
904	645	Versioned PVF execution APIs	{I4-refactor}	t	f	\N	11	2023-05-06 22:04:52+00	\N	2024-09-25 14:49:58.209927+00	\N
905	647	Fix check_bootnodes job to only fail on some percentage	{I3-annoyance}	t	f	\N	11	2023-05-03 15:47:16+00	\N	2024-09-25 14:49:58.209927+00	\N
906	176	Pallet Syntax: Analysis of `T` consistency	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-05-01 10:02:38+00	\N	2024-09-25 14:49:58.209927+00	\N
907	412	Research and build testing infra with realistic scenarios for elections	{I10-unconfirmed}	t	f	\N	11	2023-05-01 08:03:20+00	\N	2024-09-25 14:49:58.209927+00	\N
908	177	[FRAME] Simplify `benchmark pallet` invocation	{T1-FRAME}	t	f	\N	11	2023-04-28 11:42:34+00	\N	2024-09-25 14:49:58.209927+00	\N
909	509	Debug assert triggered in `Notifications`	{I2-bug}	t	f	\N	11	2023-04-27 09:58:28+00	\N	2024-09-25 14:49:58.209927+00	\N
910	12	Support syncing from `LightSyncState`	{I5-enhancement}	t	f	\N	11	2023-04-26 22:33:32+00	\N	2024-09-25 14:49:58.209927+00	\N
911	414	Staking `force_unbond`	{C1-mentor,T2-pallets,D0-easy}	t	f	\N	11	2023-04-26 12:06:06+00	\N	2024-09-25 14:49:58.209927+00	\N
912	180	[Deprecation] `#[pallet:call_index]` should be mandatory except in `dev_mode`	{I5-enhancement,T1-FRAME,T13-deprecation}	t	f	\N	11	2023-04-24 03:51:53+00	\N	2024-09-25 14:49:58.209927+00	\N
913	183	TrieError -> InvalidStateRoot when running try-runtime on-runtime-upgrade	{I2-bug,T1-FRAME}	t	f	\N	11	2023-04-21 11:49:12+00	\N	2024-09-25 14:49:58.209927+00	\N
914	417	Improve `ElectionBounds` and related types	{}	t	f	\N	11	2023-04-20 15:18:22+00	\N	2024-09-25 14:49:58.209927+00	\N
915	510	Investigate how to store pending responses in `ChainSync` efficiently	{I9-optimisation,I4-refactor,D0-easy}	t	f	\N	11	2023-04-20 12:45:39+00	\N	2024-09-25 14:49:58.209927+00	\N
916	184	Properly benchmark on_initize hook weight	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-04-20 01:55:24+00	\N	2024-09-25 14:49:58.209927+00	\N
917	185	Make `GenesisConfig` printable	{T1-FRAME}	t	f	\N	11	2023-04-19 13:04:08+00	\N	2024-09-25 14:49:58.209927+00	\N
918	483	Make block time configurable	{I5-enhancement}	t	f	\N	11	2023-04-19 13:02:53+00	\N	2024-09-25 14:49:58.209927+00	\N
919	652	PVF: Research the use of CPU virtualization for PVF execution 	{}	t	f	\N	11	2023-04-18 16:42:44+00	\N	2024-09-25 14:49:58.209927+00	\N
920	13	Slow block import	{I10-unconfirmed}	t	f	\N	11	2023-04-18 15:30:38+00	\N	2024-09-25 14:49:58.209927+00	\N
921	653	Create complete and exhaustive list of sources of indeterminism in PVF	{}	t	f	\N	11	2023-04-17 08:19:29+00	\N	2024-09-25 14:49:58.209927+00	\N
922	187	Vision: Pallet syntax improvement	{I6-meta,T1-FRAME}	t	f	\N	11	2023-04-13 16:33:56+00	\N	2024-09-25 14:49:58.209927+00	\N
923	511	Keep peers sorted by reputation in `PeerStore`	{I9-optimisation}	t	f	\N	11	2023-04-13 12:09:28+00	\N	2024-09-25 14:49:58.209927+00	\N
924	655	More XCM e2e tests	{T6-XCM,T10-tests}	t	f	\N	11	2023-04-13 09:58:16+00	\N	2024-09-25 14:49:58.209927+00	\N
925	110	contracts: Include input data in `Called` and `Instantiated` event	{I5-enhancement,D0-easy}	t	f	\N	11	2023-04-12 20:54:52+00	\N	2024-09-25 14:49:58.209927+00	\N
926	656	Measure transaction and messaging throughput	{T10-tests}	t	f	\N	11	2023-04-12 18:24:41+00	\N	2024-09-25 14:49:58.209927+00	\N
927	111	Make pallet_contracts compatible with the Ethereum RPC.	{I5-enhancement,D2-substantial}	t	f	\N	11	2023-04-12 12:28:40+00	\N	2024-09-25 14:49:58.209927+00	\N
928	657	Run preparation for all existing PVFs on the network before a release updating wasmtime 	{}	t	f	\N	11	2023-04-11 09:48:57+00	\N	2024-09-25 14:49:58.209927+00	\N
929	658	Check on message handling for parathreads	{}	t	f	\N	11	2023-04-11 07:40:03+00	\N	2024-09-25 14:49:58.209927+00	\N
930	659	PVF: Throw error if worker process cannot spawn necessary threads	{C1-mentor}	t	f	\N	11	2023-04-10 17:06:06+00	\N	2024-09-25 14:49:58.209927+00	\N
931	661	PVF: Consider treating `RuntimeConstruction` as an internal execution error	{}	t	f	\N	11	2023-04-10 16:39:07+00	\N	2024-09-25 14:49:58.209927+00	\N
932	418	Staking: allow nomination mirroring	{I5-enhancement,T2-pallets}	t	f	\N	11	2023-04-09 12:59:45+00	\N	2024-09-25 14:49:58.209927+00	\N
933	189	Incorporate fuzzers into conformance tests	{C1-mentor,T1-FRAME,T10-tests}	t	f	\N	11	2023-04-07 19:10:19+00	\N	2024-09-25 14:49:58.209927+00	\N
934	666	Remove distinction between parachains/parathreads in host configuration	{}	t	f	\N	11	2023-04-07 15:25:56+00	\N	2024-09-25 14:49:58.209927+00	\N
935	668	Remove old parathread queue configuration from host configuration	{}	t	f	\N	11	2023-04-07 14:50:50+00	\N	2024-09-25 14:49:58.209927+00	\N
936	669	Charge core time chains fees for upgrading their runtime code	{}	t	f	\N	11	2023-04-07 14:50:23+00	\N	2024-09-25 14:49:58.209927+00	\N
937	670	 Api called for an unknown Block: Header was not found in the database	{}	t	f	\N	11	2023-04-06 15:57:54+00	\N	2024-09-25 14:49:58.209927+00	\N
938	671	Errors "error flushing netlink socket"  after upgrade to v0.9.41	{}	t	f	\N	11	2023-04-06 14:36:00+00	\N	2024-09-25 14:49:58.209927+00	\N
939	190	Make composite_enum generalized	{C1-mentor,I4-refactor,T1-FRAME,D2-substantial}	t	f	\N	11	2023-04-04 21:52:24+00	\N	2024-09-25 14:49:58.209927+00	\N
940	674	RFC: Delegation Statements	{I5-enhancement}	t	f	\N	11	2023-04-04 13:51:54+00	\N	2024-09-25 14:49:58.209927+00	\N
941	112	Contract: Native function to retrieve entire call input bytes array	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2023-04-04 08:50:54+00	\N	2024-09-25 14:49:58.209927+00	\N
942	15	Add explicit feature flags for non-MVP WASM features implicitly supported by `wasmtime`	{}	t	f	\N	11	2023-04-04 08:18:40+00	\N	2024-09-25 14:49:58.209927+00	\N
943	192	Benchmark or remove hard-coded pallet weights	{I6-meta,T1-FRAME}	t	f	\N	11	2023-04-03 16:08:55+00	\N	2024-09-25 14:49:58.209927+00	\N
944	194	[FRAME core] Refactor pallet benchmarking	{I4-refactor,T1-FRAME,D1-medium}	t	f	\N	11	2023-04-03 10:07:33+00	\N	2024-09-25 14:49:58.209927+00	\N
945	513	Investigate bandwidth usage	{I9-optimisation}	t	f	\N	11	2023-04-03 07:19:42+00	\N	2024-09-25 14:49:58.209927+00	\N
946	195	Scheduler: an overweight task removed silently 	{C1-mentor,I2-bug,T1-FRAME,D0-easy}	t	f	\N	11	2023-03-31 16:27:04+00	\N	2024-09-25 14:49:58.209927+00	\N
947	16	[rpc server]: change `tokio::Handle::block_in_place` to `tokio::Handle::block_on`	{D1-medium}	t	f	\N	11	2023-03-30 21:36:35+00	\N	2024-09-25 14:49:58.209927+00	\N
948	677	PVF: Compromised artifact file integrity can lead to disputes	{C1-mentor}	t	f	\N	11	2023-03-28 16:27:35+00	\N	2024-09-25 14:49:58.209927+00	\N
949	678	Update all references to the old Matrix server	{}	t	f	\N	11	2023-03-28 15:34:13+00	\N	2024-09-25 14:49:58.209927+00	\N
950	196	Vision: Allow users to limit weight spent in categories of calls	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-03-27 21:54:24+00	\N	2024-09-25 14:49:58.209927+00	\N
951	419	Vision: Path to removing `reduce` from NPoS protocol	{I6-meta,D3-involved}	t	f	\N	11	2023-03-27 15:23:45+00	\N	2024-09-25 14:49:58.209927+00	\N
952	197	Adding CallFilter to calling pallets	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-03-27 14:15:14+00	\N	2024-09-25 14:49:58.209927+00	\N
953	484	Fast unstake `try_state` check fails on Westend	{}	t	f	\N	11	2023-03-26 18:14:12+00	\N	2024-09-25 14:49:58.209927+00	\N
954	420	Staking: Chilled validators should wait a fixed period before they can validate again.	{}	t	f	\N	11	2023-03-26 01:28:10+00	\N	2024-09-25 14:49:58.209927+00	\N
955	17	Deprecate the `ext_storage_root_version_2` and `ext_default_child_storage_root_version_2` host functions	{I4-refactor,D0-easy}	t	f	\N	11	2023-03-24 23:45:04+00	\N	2024-09-25 14:49:58.209927+00	\N
956	681	More efficient disputes query	{}	t	f	\N	11	2023-03-24 09:47:17+00	\N	2024-09-25 14:49:58.209927+00	\N
957	377	Benchmark No-OP host function	{D0-easy}	t	f	\N	11	2023-03-23 15:58:15+00	\N	2024-09-25 14:49:58.209927+00	\N
958	682	Runtime metric `polkadot_parachain_create_inherent_bitfields_signature_checks` is not exported	{}	t	f	\N	11	2023-03-23 14:08:51+00	\N	2024-09-25 14:49:58.209927+00	\N
959	683	The time required for a signature validation of dispute votes in runtime varies a lot	{}	t	f	\N	11	2023-03-23 13:46:43+00	\N	2024-09-25 14:49:58.209927+00	\N
960	378	Deprecate raw `RuntimeDbWeight::reads_writes` calls	{I4-refactor,D0-easy}	t	f	\N	11	2023-03-23 11:50:46+00	\N	2024-09-25 14:49:58.209927+00	\N
961	421	[Fix] Staking proportional_ledger_slash_works test.	{T10-tests}	t	f	\N	11	2023-03-21 20:57:51+00	\N	2024-09-25 14:49:58.209927+00	\N
962	199	Introduce checked `PerThing` arithmetics	{C1-mentor,I4-refactor,I5-enhancement,T1-FRAME,D0-easy}	t	f	\N	11	2023-03-21 15:09:06+00	\N	2024-09-25 14:49:58.209927+00	\N
963	686	[XCM]  META: XCM additions	{T6-XCM,I5-enhancement,I6-meta}	t	f	\N	11	2023-03-21 13:43:39+00	\N	2024-09-25 14:49:58.209927+00	\N
964	200	Referenda proposal not moving to confirming automatically	{T1-FRAME}	t	f	\N	11	2023-03-20 21:13:16+00	\N	2024-09-25 14:49:58.209927+00	\N
965	18	Run block import thread at higher priority	{I9-optimisation}	t	f	\N	11	2023-03-20 13:06:57+00	\N	2024-09-25 14:49:58.209927+00	\N
966	113	contracts: Enable wasm proposals	{I5-enhancement,D0-easy}	t	f	\N	11	2023-03-19 18:35:58+00	\N	2024-09-25 14:49:58.209927+00	\N
967	114	contracts: Hybrid chain support	{I6-meta,D3-involved}	t	f	\N	11	2023-03-19 17:31:10+00	\N	2024-09-25 14:49:58.209927+00	\N
968	115	contracts: Support RISC-V bytecode	{I5-enhancement,I6-meta}	t	f	\N	11	2023-03-19 16:27:11+00	\N	2024-09-25 14:49:58.209927+00	\N
969	689	dispute-coordinator: subsystem stalls during dispute load test	{I2-bug}	t	f	\N	11	2023-03-18 11:22:29+00	\N	2024-09-25 14:49:58.209927+00	\N
970	690	Estimate Fees for XCM	{T6-XCM,I5-enhancement}	t	f	\N	11	2023-03-15 01:18:09+00	\N	2024-09-25 14:49:58.209927+00	\N
971	691	Add Guide For Network Scale Testing (Versi)	{T11-documentation}	t	f	\N	11	2023-03-14 18:30:24+00	\N	2024-09-25 14:49:58.209927+00	\N
972	201	[Multi-Asset Treasury] Implement treasury pallet to be more generic	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-03-14 17:39:27+00	\N	2024-09-25 14:49:58.209927+00	\N
973	694	Executor parameters change may affect PVF validity and executability retrospectively	{}	t	f	\N	11	2023-03-14 16:48:16+00	\N	2024-09-25 14:49:58.209927+00	\N
974	203	Testing defensive paths. 	{I5-enhancement,T1-FRAME,T10-tests}	t	f	\N	11	2023-03-14 13:06:24+00	\N	2024-09-25 14:49:58.209927+00	\N
975	204	Proxies to have delegate -> proxies reverse lookup 	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-03-14 05:34:19+00	\N	2024-09-25 14:49:58.209927+00	\N
976	696	Use of variable in printf format string	{}	t	f	\N	11	2023-03-13 13:52:55+00	\N	2024-09-25 14:49:58.209927+00	\N
977	697	Should not have unused variables	{}	t	f	\N	11	2023-03-13 13:45:22+00	\N	2024-09-25 14:49:58.209927+00	\N
978	423	Improvements to staking and EPM integration tests	{}	t	f	\N	11	2023-03-13 08:53:15+00	\N	2024-09-25 14:49:58.209927+00	\N
979	424	Staking Fuzzer to test nomination pool commission & absent calls	{I5-enhancement}	t	f	\N	11	2023-03-13 06:19:44+00	\N	2024-09-25 14:49:58.209927+00	\N
980	698	XCM weight meter	{T6-XCM}	t	f	\N	11	2023-03-11 08:32:53+00	\N	2024-09-25 14:49:58.209927+00	\N
981	699	Configurable Runtimes	{}	t	f	\N	11	2023-03-09 02:06:28+00	\N	2024-09-25 14:49:58.209927+00	\N
982	700	Flexible proxy variant to cover all runtime pallets	{I10-unconfirmed}	t	f	\N	11	2023-03-08 23:12:01+00	\N	2024-09-25 14:49:58.209927+00	\N
983	425	Automate the update logic for `MinNominatorBond` and `MinValidatorBond`	{I5-enhancement}	t	f	\N	11	2023-03-06 15:49:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1137	250	BiBounded{Vec,BTreeMap}	{T1-FRAME}	t	f	\N	11	2022-09-13 16:14:40+00	\N	2024-09-25 14:49:58.209927+00	\N
984	516	Merge `Protocol` and `Notifications`	{I9-optimisation,I4-refactor,D1-medium}	t	f	\N	11	2023-03-06 09:45:01+00	\N	2024-09-25 14:49:58.209927+00	\N
985	517	Use libp2p's memory transport for `NetworkConfiguration::new_memory`	{I2-bug,I4-refactor,D0-easy}	t	f	\N	11	2023-03-05 10:18:55+00	\N	2024-09-25 14:49:58.209927+00	\N
986	518	Refactoring: move peer addressed from `Discovery` to `Peerset` data store	{I4-refactor}	t	f	\N	11	2023-03-03 14:40:36+00	\N	2024-09-25 14:49:58.209927+00	\N
987	206	[FRAME Core] General system for recognising and executing service work	{T1-FRAME}	t	f	\N	11	2023-03-03 14:21:18+00	\N	2024-09-25 14:49:58.209927+00	\N
988	207	[FRAME Core] General storage-usage system	{T1-FRAME}	t	f	\N	11	2023-03-03 14:00:51+00	\N	2024-09-25 14:49:58.209927+00	\N
989	2339	Honor the execution environment on collators	{}	t	f	\N	11	2023-03-03 13:41:28+00	\N	2024-09-25 14:49:58.209927+00	\N
990	703	Collator Executor Environment Parameters	{}	t	f	\N	11	2023-03-03 13:27:46+00	\N	2024-09-25 14:49:58.209927+00	\N
991	117	contracts: Allow to associate metadata with code hashes	{I5-enhancement,D3-involved}	t	f	\N	11	2023-03-02 19:42:59+00	\N	2024-09-25 14:49:58.209927+00	\N
992	208	Extend `GetCallMetadata` with indices	{C1-mentor,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2023-03-02 14:19:09+00	\N	2024-09-25 14:49:58.209927+00	\N
993	1131	[CI/CD] Check runtime upgrade works job	{}	t	f	\N	11	2023-03-02 09:44:37+00	\N	2024-09-25 14:49:58.209927+00	\N
994	20	Remove `parity-wasm` dependency	{I4-refactor}	t	f	\N	11	2023-03-01 07:58:18+00	\N	2024-09-25 14:49:58.209927+00	\N
995	72	Ensure that collators respect the backers timeout	{I5-enhancement}	t	f	\N	11	2023-02-28 20:37:33+00	\N	2024-09-25 14:49:58.209927+00	\N
996	705	Asynchronous Backing: implementers' guide	{T11-documentation}	t	f	\N	11	2023-02-28 05:06:46+00	\N	2024-09-25 14:49:58.209927+00	\N
997	210	Automatic checking `try_state` hooks in tests	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-02-24 14:54:21+00	\N	2024-09-25 14:49:58.209927+00	\N
998	211	Moving un-opinionated types and utilities outside of FRAME where possible.	{I4-refactor,T1-FRAME}	t	f	\N	11	2023-02-24 06:39:06+00	\N	2024-09-25 14:49:58.209927+00	\N
999	707	Add a `Call` for parachain origins to cancel their own runtime upgrade	{}	t	f	\N	11	2023-02-23 23:33:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1000	21	Consider patching `memset`/`memcpy` inside of WASM to call the native implementations instead	{I9-optimisation}	t	f	\N	11	2023-02-22 16:22:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1001	22	Fix or remove `storage_keys` and `storage_pairs` RPC APIs	{}	t	f	\N	11	2023-02-22 07:47:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1002	212	QOL improvement: fix incorrect error that shows up in rust-analyzer for pallet storages	{T1-FRAME,D3-involved}	t	f	\N	11	2023-02-21 20:42:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1003	213	Fix pallet error spam when there is really just one simple error	{T1-FRAME,D3-involved}	t	f	\N	11	2023-02-21 18:14:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1004	519	Free more full node slots on the network	{}	t	f	\N	11	2023-02-20 15:21:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1005	710	Implement parathreads while ignoring AB	{}	t	f	\N	11	2023-02-20 14:52:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1006	520	Consider making `SyncOracle` asynchronous	{I4-refactor,D0-easy}	t	f	\N	11	2023-02-20 09:24:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1007	427	Runtime API for staking inflation	{I5-enhancement}	t	f	\N	11	2023-02-17 19:27:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1008	711	Possibly outdated hardware requirements for running validator nodes	{}	t	f	\N	11	2023-02-17 13:28:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1009	521	Move syncing-related metrics to `SyncingEngine`	{I4-refactor,D0-easy}	t	f	\N	11	2023-02-17 11:39:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1010	1122	beefy: support custom signature hashing	{I5-enhancement}	t	f	\N	11	2023-02-17 08:57:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1011	712	Create `ProxyKind` specifically for bidding on parathread blockspace	{}	t	f	\N	11	2023-02-16 20:17:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1012	379	Dynamic number of benchmark repetitions	{}	t	f	\N	11	2023-02-16 16:43:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1013	713	PVF execution queue priorities	{}	t	f	\N	11	2023-02-15 15:03:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1014	428	Unify staking related runtime APIs	{}	t	f	\N	11	2023-02-15 01:11:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1015	429	Rename `NposSolver` trait to `ElectionSolver`	{I10-unconfirmed}	t	f	\N	11	2023-02-15 01:03:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1016	716	Better way to handle staging runtime methods	{}	t	f	\N	11	2023-02-14 09:52:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1017	717	Review calls requires root origins and determine if we can reduce the requirement	{C1-mentor,I4-refactor,D0-easy,C2-good-first-issue}	t	f	\N	11	2023-02-13 22:55:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1018	23	Avoid calls to contains_key on small value.	{I5-enhancement}	t	f	\N	11	2023-02-13 22:04:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1019	214	Test UI of `storage_alias`	{C1-mentor,T1-FRAME,T10-tests,D0-easy}	t	f	\N	11	2023-02-13 15:50:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1020	216	[FRAME Core] Add support for `view_functions`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-02-10 11:11:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1021	24	substrate can't build without rocksdb installed	{}	t	f	\N	11	2023-02-09 20:29:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1022	217	Improper error type is returned when a runtime API method is not available	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-02-08 22:37:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1023	430	Come up with more scenarios for the Staking integration test	{C1-mentor}	t	f	\N	11	2023-02-08 19:02:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1024	719	Remove polling from PVF preparation memory tracker	{}	t	f	\N	11	2023-02-08 09:45:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1025	25	`GenesisConfig` in a native runtime free world	{I4-refactor,T1-FRAME,D1-medium}	t	f	\N	11	2023-02-07 20:03:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1026	26	[Request] Trie cache metrics	{}	t	f	\N	11	2023-02-07 19:48:07+00	\N	2024-09-25 14:49:58.209927+00	\N
1027	27	Remove `sp-api` requirement on compile time bounds	{I4-refactor}	t	f	\N	11	2023-02-07 19:24:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1028	218	Create some compile-time notion of "runtime mode"	{T1-FRAME}	t	f	\N	11	2023-02-07 05:46:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1029	522	Keep or remove `--ipfs-server`	{I10-unconfirmed}	t	f	\N	11	2023-02-07 02:19:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1030	721	Utility tool to analyse distributions of performance data	{}	t	f	\N	11	2023-02-06 16:36:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1031	219	utility.dispatch_as error handling	{C1-mentor,I5-enhancement,T1-FRAME,D0-easy}	t	f	\N	11	2023-02-03 18:16:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1032	722	XCM: Arbitrary Origin Aliases	{T6-XCM}	t	f	\N	11	2023-02-03 13:30:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1033	220	`ensure_none` naming is misleading	{I9-optimisation,T1-FRAME}	t	f	\N	11	2023-01-30 23:32:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1034	724	Research and implement runtime API so node can validate bids (valid account, minimum price, ...)	{}	t	f	\N	11	2023-01-29 12:30:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1035	725	Define extrinsic for ordering, again based on optimal controller (fixed price, getting burned/going to treasury + tip for block producer)	{}	t	f	\N	11	2023-01-29 11:21:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1036	726	Implement optimal price controller for parathreads, runtime	{}	t	f	\N	11	2023-01-29 11:20:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1037	221	`Defensive` ops API design	{C1-mentor,I4-refactor,T1-FRAME,D0-easy}	t	f	\N	11	2023-01-28 23:49:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1038	223	[Deprecation] remove storage getters in FRAME	{T1-FRAME,T13-deprecation,D0-easy}	t	f	\N	11	2023-01-28 23:02:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1039	224	FRAME: Introduce `shelve`/`restore` to `nonfungible`/`nonfungibles`	{T1-FRAME}	t	f	\N	11	2023-01-27 16:17:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1040	225	FRAME: Conformance tests for `fungible` API	{T1-FRAME,T10-tests}	t	f	\N	11	2023-01-27 16:14:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1041	226	FRAME: Move pallets over to use `fungible` traits	{I6-meta,T1-FRAME}	t	f	\N	11	2023-01-27 16:13:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1042	523	Announce "capabilities" over the network?	{}	t	f	\N	11	2023-01-27 13:42:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1043	227	Add a dust removal whitelist to `pallet-balances`	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2023-01-25 12:08:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1044	729	`approval-voting`: merge tranche 0 assignments	{I9-optimisation}	t	f	\N	11	2023-01-24 11:40:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1045	730	`approval-voting`: experiment with batching signature checks	{}	t	f	\N	11	2023-01-23 12:47:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1046	731	`approval-voting`: implement parallel processing of signature checks.	{I4-refactor}	t	f	\N	11	2023-01-23 12:09:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1047	228	Assets: Implement Inactive balance tracking in Assets pallet	{T1-FRAME}	t	f	\N	11	2023-01-20 20:06:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1048	28	Move `sc-network-gossip` into Grandpa	{I4-refactor}	t	f	\N	11	2023-01-20 09:27:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1049	734	Deprecate `SessionInfo`	{T13-deprecation}	t	f	\N	11	2023-01-19 17:07:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1050	229	Fix `pallet_offences_benchmarking::check_events`	{I4-refactor,T1-FRAME,T10-tests,D1-medium}	t	f	\N	11	2023-01-19 13:31:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1051	230	Runtime API to dispatch call and return events	{C1-mentor,I5-enhancement,T1-FRAME,T4-runtime_API,C2-good-first-issue}	t	f	\N	11	2023-01-17 21:11:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1052	231	Expiry time for MultiSig calls	{T1-FRAME}	t	f	\N	11	2023-01-17 17:10:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1053	736	XCM: Create general asset weight weighing framework	{T6-XCM}	t	f	\N	11	2023-01-16 16:57:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1054	738	XCM executor should use transfer over withdraw/deposit	{T6-XCM}	t	f	\N	11	2023-01-16 09:16:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1055	233	Detect storage migration requirements in CI	{I5-enhancement,T1-FRAME}	t	f	\N	11	2023-01-11 14:14:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1056	234	Staking `try_state` times out	{T1-FRAME,T10-tests}	t	f	\N	11	2023-01-10 14:26:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1057	739	guide: remove outdated references to jobs	{T11-documentation}	t	f	\N	11	2023-01-09 11:28:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1058	740	Parachain Auctions: De-registration of parachain participating on auction is possible	{}	t	f	\N	11	2023-01-05 21:15:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1059	742	Time Disputes	{I6-meta}	t	f	\N	11	2023-01-05 14:27:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1060	235	Allow runtime-wide `TryState` checks	{C1-mentor,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2023-01-04 12:38:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1061	431	Re-evaluate the length of phases in Election provider multi phase	{}	t	f	\N	11	2023-01-02 22:01:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1062	743	Failed to validate a candidate: PrepareError panic in cranelift codegen	{}	t	f	\N	11	2023-01-02 21:17:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1063	432	Way to enable/disable a phase in EPM	{C1-mentor,D0-easy}	t	f	\N	11	2023-01-02 20:58:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1064	433	Tracker issue for cleaning up old non-paged exposure logic in staking pallet	{}	t	f	\N	11	2022-12-29 22:00:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1065	744	PVF execution and preparation queues refactoring	{I4-refactor}	t	f	\N	11	2022-12-23 11:55:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1066	745	Pre-checking: reject PVFs where preparation surpassed threshold memory usage	{}	t	f	\N	11	2022-12-22 17:49:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1067	746	Automated Dispute Load Test	{}	t	f	\N	11	2022-12-21 14:22:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1068	747	dispute-distribution and dispute-coordinator should be a noop for full nodes	{}	t	f	\N	11	2022-12-21 13:57:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1069	434	NPoS: Auto-compounding pools	{I5-enhancement}	t	f	\N	11	2022-12-16 20:19:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1070	435	NPoS: Robot-pools	{I6-meta}	t	f	\N	11	2022-12-16 20:17:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1071	749	cannot connect to internal telemetry with self signed certificate	{}	t	f	\N	11	2022-12-15 16:22:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1072	73	collator-selection pallet: misleading Validator/Collator terminology	{}	t	f	\N	11	2022-12-14 23:23:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1073	436	FRAME's misleading Validator/Collator terminology	{}	t	f	\N	11	2022-12-14 23:18:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1074	29	Convert `TrieBackendEssence::{keys, pairs}` to return an iterator	{I9-optimisation,I4-refactor}	t	f	\N	11	2022-12-14 04:53:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1075	236	Tokens: Revamp locking & reserving	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-12-13 12:42:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1076	1123	client/beefy: Create some mechanism to avoid DDoS gossip	{}	t	f	\N	11	2022-12-13 12:20:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1077	237	Fix reserved amounts for pure proxies	{T1-FRAME}	t	f	\N	11	2022-12-12 14:32:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1078	238	OpenGov: Make referenda free to participate in	{T1-FRAME}	t	f	\N	11	2022-12-09 11:34:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1079	437	Improve `ElectionFailed` error tracability	{I3-annoyance,D0-easy}	t	f	\N	11	2022-12-07 21:08:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1080	438	maximize the `remote-externalities` performance	{I9-optimisation}	t	f	\N	11	2022-12-07 16:10:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1081	524	Implement Bitswap protocol using notifications protocol	{I2-bug,D1-medium}	t	f	\N	11	2022-12-06 11:14:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1082	750	Disputes Slashing/Hardening	{I6-meta}	t	f	\N	11	2022-12-05 09:43:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1083	751	Scaling: Get rid of maxValidators configuration	{I6-meta}	t	f	\N	11	2022-12-05 09:24:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1084	239	Tracking issue for adding `try_state` hook to all pallets. 	{C1-mentor,I6-meta,T1-FRAME}	t	f	\N	11	2022-12-02 18:46:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1085	240	State Diff Recorder + Guard	{I5-enhancement,T1-FRAME,D2-substantial}	t	f	\N	11	2022-12-01 22:14:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1440	82	Support custom storage proof from the relay-chain	{}	t	f	\N	11	2021-02-08 11:57:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1086	441	pallet-staking: track total unstaking amount	{C1-mentor,I5-enhancement}	t	f	\N	11	2022-11-28 19:54:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1087	1138	[FRAME] VersionedCall	{C1-mentor,I4-refactor,D1-medium,C2-good-first-issue}	t	f	\N	11	2022-11-27 22:07:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1088	752	Revisit and unify error handling in subsystems	{I4-refactor}	t	f	\N	11	2022-11-25 19:25:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1089	1133	Assets - TakeFirstAssetTrader tests improve	{T6-XCM}	t	f	\N	11	2022-11-25 16:22:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1090	95	Make request/response protocols outbound only where possible	{I5-enhancement}	t	f	\N	11	2022-11-25 08:47:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1091	442	Consider automatic rebaging when rewards are received or slashes happen	{I5-enhancement}	t	f	\N	11	2022-11-20 13:33:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1092	525	Fork sync targets are handled inefficiently	{I9-optimisation,T10-tests}	t	f	\N	11	2022-11-18 12:05:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1093	443	[Staking] Approval Stake tracking	{}	t	f	\N	11	2022-11-16 11:42:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1094	444	nomination-pools: handle changes to `MinCreateBond`	{I5-enhancement}	t	f	\N	11	2022-11-16 09:04:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1095	753	wrong spending limit comments in Kusama governance config	{}	t	f	\N	11	2022-11-15 15:31:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1096	755	Remove all usages of `relay_dispatch_queue_size`	{I4-refactor}	t	f	\N	11	2022-11-14 14:08:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1097	90	Generalized Collective Extension Pallet(s)	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-11-11 07:14:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1098	445	allow swapping from one pool to another	{I10-unconfirmed}	t	f	\N	11	2022-11-09 15:57:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1099	242	auditing attribute macro for FRAME pallets	{T1-FRAME,D1-medium}	t	f	\N	11	2022-11-09 06:15:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1100	446	Improve Benchmarks for Pallet Election Provider Multiphase	{}	t	f	\N	11	2022-11-08 18:51:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1101	756	Migrations are not transactional	{}	t	f	\N	11	2022-11-08 13:56:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1102	757	Found 3 strongly connected components which includes at least one cycle each	{}	t	f	\N	11	2022-11-07 13:55:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1103	381	Can benchmarking functionality have used externalities extensions? 	{I5-enhancement}	t	f	\N	11	2022-10-31 11:59:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1104	448	Refactor `NposSolver` to be generic over the election algorithm	{I4-refactor,I10-unconfirmed}	t	f	\N	11	2022-10-31 08:11:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1105	382	Idea: Reflections for `WeightInfo` functions	{I5-enhancement,D1-medium}	t	f	\N	11	2022-10-29 21:13:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1106	245	Vision: Host functions and database support for non-Merklised-persistent data structures	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-10-28 11:53:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1107	761	Compute session topology ahead-of-time	{I3-annoyance,I4-refactor}	t	f	\N	11	2022-10-26 21:51:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1108	762	Remove references to Peer ID from session topology	{C1-mentor,I4-refactor}	t	f	\N	11	2022-10-26 21:46:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1109	383	Block number inconsistency between bench tests and runs	{I4-refactor}	t	f	\N	11	2022-10-24 20:59:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1110	763	`libp2p_kad::handler` high warning rate on Kusama after upgrade to 0.9.30	{}	t	f	\N	11	2022-10-21 07:49:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1111	246	Allow currency slashing to fail	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2022-10-19 14:05:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1112	247	Switch proc macro docs to be on re-exports so we can have doc links to outer crate items	{C1-mentor,T1-FRAME,D0-easy}	t	f	\N	11	2022-10-18 16:23:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1113	764	refactor tests to remove overseer send and recv timeouts	{I3-annoyance,T10-tests}	t	f	\N	11	2022-10-12 20:00:17+00	\N	2024-09-25 14:49:58.209927+00	\N
1114	765	Polkanomicon	{}	t	f	\N	11	2022-10-12 13:47:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1115	91	Make Assets Pallet's Privileged Roles `Option`	{C1-mentor,I5-enhancement,T1-FRAME}	t	f	\N	11	2022-10-10 05:52:38+00	\N	2024-09-25 14:49:58.209927+00	\N
1116	487	XCM: Proper Asset Checking	{T6-XCM,I5-enhancement}	t	f	\N	11	2022-10-07 11:13:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1117	488	XCM: Graceful Deletion of Overweight Messages	{I5-enhancement}	t	f	\N	11	2022-10-07 11:02:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1118	489	XCM: Message Queues	{T6-XCM,I9-optimisation}	t	f	\N	11	2022-10-07 10:58:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1119	526	Peering mismatch	{I2-bug}	t	f	\N	11	2022-10-06 11:57:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1120	766	ZombieNet: remove async-backing feature tests when integration is successfully completed	{T10-tests}	t	f	\N	11	2022-10-06 10:14:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1121	31	RUSTSEC-2021-0139: ansi_term is Unmaintained	{I10-unconfirmed}	t	f	\N	11	2022-10-06 06:34:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1122	767	Handle OOM gracefully in PVF execution	{}	t	f	\N	11	2022-10-04 12:08:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1123	450	election-provider: allow smaller solutions.	{I5-enhancement}	t	f	\N	11	2022-10-03 11:21:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1124	772	Figure out proper operational proof size weight	{}	t	f	\N	11	2022-10-02 09:59:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1125	773	A validator panics in libp2p-swarm	{I2-bug}	t	f	\N	11	2022-09-29 12:16:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1126	774	easy: av-store does not keep assumed invariant of checked data	{D0-easy}	t	f	\N	11	2022-09-29 08:04:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1127	775	Provide stub logging host function	{I5-enhancement}	t	f	\N	11	2022-09-27 14:25:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1128	451	Reap stash for an un-decodable staking ledger	{}	t	f	\N	11	2022-09-27 09:55:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1129	32	Vision: Note on the API design that involves code auto-generation	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-09-22 16:35:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1130	776	Double check memory usage is bounded in case of long finality stalls	{}	t	f	\N	11	2022-09-22 10:11:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1131	452	Add a migration helper for reducing HistoryDepth config value in staking pallet	{}	t	f	\N	11	2022-09-21 15:08:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1132	33	Investigate Cranelift's new incremental compilation cache	{I9-optimisation}	t	f	\N	11	2022-09-21 08:10:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1133	453	nomination-pools: Funds mistakenly sent to pool bonded account	{I3-annoyance}	t	f	\N	11	2022-09-20 08:47:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1134	249	pallet::call macro does not preserve lint attributes	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-09-19 21:23:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1135	777	remove redundant dependencies in subsystems	{I3-annoyance,I4-refactor}	t	f	\N	11	2022-09-14 22:30:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1136	778	Request/Response adaptive timeouts	{I3-annoyance}	t	f	\N	11	2022-09-14 00:04:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1138	384	Record PoV size in `benchmark overhead`	{I5-enhancement,D1-medium}	t	f	\N	11	2022-09-13 12:17:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1139	34	Make Warp Sync the default Sync mode	{I5-enhancement}	t	f	\N	11	2022-09-13 11:33:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1140	35	Support Warp sync from non genesis	{I5-enhancement}	t	f	\N	11	2022-09-13 11:31:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1141	779	Optimize collator-protocol advertisement fetching rule	{I9-optimisation}	t	f	\N	11	2022-09-13 05:06:07+00	\N	2024-09-25 14:49:58.209927+00	\N
1142	780	FungiblesMutateAdapter passes keep_alive true when doing internal transfers	{T6-XCM}	t	f	\N	11	2022-09-12 16:01:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1143	251	Vision: Random call generator for fuzz-testing	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-09-12 13:32:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1144	527	show ETA while syncing	{I5-enhancement,D0-easy}	t	f	\N	11	2022-09-12 09:08:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1145	385	Remove legacy benchmarking code	{I4-refactor,D0-easy}	t	f	\N	11	2022-09-08 13:09:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1146	528	Node keeps loosing peers.	{I2-bug}	t	f	\N	11	2022-09-08 13:07:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1147	36	Enable the bulk memory operations WASM feature	{I9-optimisation,T1-FRAME}	t	f	\N	11	2022-09-08 13:06:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1148	255	Tracking issue for bounding `pallet-staking` storage items	{I6-meta,T1-FRAME,D3-involved}	t	f	\N	11	2022-09-05 11:47:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1149	256	The rest of the way to Weights V2 (Tracking Issue)	{I6-meta,T1-FRAME}	t	f	\N	11	2022-09-02 17:45:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1150	257	Transaction priority should take into account the inclusion fee	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-09-02 10:54:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1151	781	`SystemClock` is duplicated on a lot of places in the project	{I3-annoyance}	t	f	\N	11	2022-09-01 11:26:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1152	782	Rework `RecentDisputes` and `ActiveDisputes` to return disputes in `BTreeMap`/`BTreeSet` instead of `Vec` 	{I3-annoyance}	t	f	\N	11	2022-09-01 11:15:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1153	784	disputes: implement validator disabling	{I6-meta}	t	f	\N	11	2022-08-31 14:01:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1154	787	Remove a redundant bench	{}	t	f	\N	11	2022-08-25 12:42:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1155	259	Syntax improvement for `ResultQuery` usage	{I3-annoyance,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2022-08-24 18:19:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1156	260	Allow any error to be specified as the `Err` variant for `ResultQuery`	{I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2022-08-24 18:09:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1157	118	Make `wasmparser` and `wasm-encoder` compatible with `no_std`	{I5-enhancement}	t	f	\N	11	2022-08-23 06:14:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1158	788	doc: Explain `QUID`, `DOLLAR` and `UNIT`	{T11-documentation}	t	f	\N	11	2022-08-22 12:13:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1159	386	CI: script for storage weight update	{I5-enhancement,D0-easy}	t	f	\N	11	2022-08-22 12:01:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1160	789	Why doesn't `Leases::<T>::iter()` affect the weight in `manage_lease_period_start`?	{}	t	f	\N	11	2022-08-21 06:31:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1161	37	Rewrite `Externalities` to take `&mut self` everywhere	{I4-refactor,D1-medium}	t	f	\N	11	2022-08-18 21:47:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1162	455	Nomination pools: allow for re-stake	{C1-mentor,I5-enhancement,D1-medium}	t	f	\N	11	2022-08-17 17:26:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1163	791	Further dispute-coordinator optimizations	{I9-optimisation}	t	f	\N	11	2022-08-16 14:44:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1164	261	Vision: `OnPostDispatch` hook	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-08-16 14:41:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1165	387	Separate DB weights for `top` and `child` keys	{}	t	f	\N	11	2022-08-16 14:39:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1166	792	Zombienet: chaos testing [main issue]	{I6-meta,T10-tests}	t	f	\N	11	2022-08-16 13:26:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1167	794	Adjust tests for `nextest`	{T10-tests}	t	f	\N	11	2022-08-15 09:44:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1168	263	Add storage size check to `construct_runtime!`	{I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2022-08-12 15:43:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1169	264	META: FRAME Macro Ideas	{I6-meta,T1-FRAME}	t	f	\N	11	2022-08-11 14:39:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1170	1134	Check ProxyFilter for `uniques::buy_item` (statemint/statemine/westmint)	{}	t	f	\N	11	2022-08-10 10:33:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1171	265	Issue with deposit_creating in Currency trait	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2022-08-08 09:44:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1172	266	Vision: Meta Transaction	{T1-FRAME}	t	f	\N	11	2022-08-08 08:50:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1173	388	Network benchmarking	{}	t	f	\N	11	2022-08-04 09:18:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1174	796	Limit AllowUnpaidExecutionFrom to Privileged Origins on Sending Chains.	{T6-XCM}	t	f	\N	11	2022-08-02 16:23:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1175	456	Clear process to update `MinimumUntrustedScore`	{}	t	f	\N	11	2022-08-02 15:31:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1176	267	[Deprecation] Deprecate individual hooks traits like `OnInitialize`	{C1-mentor,T1-FRAME,T13-deprecation,D1-medium}	t	f	\N	11	2022-07-27 18:01:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1177	798	DB corrupted: Corruption: force_consistency_checks	{}	t	f	\N	11	2022-07-25 12:56:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1178	800	Unify hostperfcheck and hw test	{}	t	f	\N	11	2022-07-19 15:15:14+00	\N	2024-09-25 14:49:58.209927+00	\N
1179	270	Consumer ref from `session.set_keys` not removed in some cases when keys are purged	{I2-bug,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2022-07-14 08:39:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1180	39	Analyse executor requirements	{I4-refactor,I10-unconfirmed}	t	f	\N	11	2022-07-08 11:23:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1181	530	Block announces handshake should use compact encoding for the block number	{}	t	f	\N	11	2022-07-06 13:41:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1182	801	Higher upper limit of `GeneralKey` in XCMv3	{}	t	f	\N	11	2022-07-05 20:08:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1183	457	EPM/Staking-miner: commit-reveal based submission	{I5-enhancement,D2-substantial}	t	f	\N	11	2022-06-30 11:32:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1184	802	Add ARM binaries to releases	{}	t	f	\N	11	2022-06-26 13:12:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1185	805	test-linux-stable is sometimes failing on master	{T10-tests}	t	f	\N	11	2022-06-23 09:46:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1186	531	Node can send multiple same block requests while syncing from other nodes	{}	t	f	\N	11	2022-06-22 09:33:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1187	807	No way to measure weight consumed by a xcm message in a particular chain	{}	t	f	\N	11	2022-06-13 16:31:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1188	271	Return the maximal key length from State Migration RPC	{T1-FRAME}	t	f	\N	11	2022-06-11 15:58:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1189	458	staking: allow nominator to bail out of the automatic reward payment	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2022-06-11 12:48:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1190	272	Pallet to enable dynamic session length	{I10-unconfirmed,T1-FRAME}	t	f	\N	11	2022-06-10 00:17:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1191	273	Improved transaction payment pallet	{T1-FRAME}	t	f	\N	11	2022-06-09 23:59:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1192	809	feature request: support import-blocks and export-blocks capabilities via RPC	{}	t	f	\N	11	2022-06-09 11:35:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1193	810	Consider giving each networking subsystem its own network-bridge and subprotocol	{I9-optimisation,I4-refactor}	t	f	\N	11	2022-06-08 11:18:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1194	1139	ensure #[pallet::constant] is actually constant	{}	t	f	\N	11	2022-06-08 02:39:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1195	811	PVF should accept data based on preimages	{I9-optimisation,I6-meta}	t	f	\N	11	2022-06-06 01:46:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1196	812	`--port` and `--listen-address` are seemingly ignored, polkadot always binds to port 30333	{}	t	f	\N	11	2022-06-04 07:05:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1197	813	Interface to expose `Call` enum structure from `construct_runtime` for XCM `Transact` callers	{T6-XCM}	t	f	\N	11	2022-06-03 13:04:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1198	275	Introduce new system origin: `DispatchedAs(origin_before, origin_after)`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-06-03 03:33:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1199	814	refactor: move NetworkBridgeIn::GossipSupport into GossipSupportSubsystem	{}	t	f	\N	11	2022-06-02 13:45:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1200	40	High CPU usage calling `Backend::usage_info`	{I9-optimisation,C1-mentor,D0-easy}	t	f	\N	11	2022-06-02 10:05:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1201	390	Automatically download the state for `benchmark storage`	{I5-enhancement}	t	f	\N	11	2022-05-31 16:28:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1202	276	`Member` should require `MaxEncodedLen`	{I4-refactor,T1-FRAME}	t	f	\N	11	2022-05-31 14:42:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1203	816	Compressed logging, always trace level	{}	t	f	\N	11	2022-05-30 12:45:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1204	41	Sassafras Protocol 	{}	t	f	\N	11	2022-05-24 16:50:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1205	819	Add Telegram/Discord as "official" field when registering an identity.	{}	t	f	\N	11	2022-05-21 00:01:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1206	42	Improve the performance of the pooling instantiation strategy on macOS	{I9-optimisation}	t	f	\N	11	2022-05-20 09:17:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1207	43	Remove the legacy instance reuse mechanism from the `wasmtime` executor	{I4-refactor}	t	f	\N	11	2022-05-20 09:11:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1208	44	Runtime allocation profiling	{I5-enhancement}	t	f	\N	11	2022-05-19 08:02:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1209	820	Unify test harness code	{}	t	f	\N	11	2022-05-19 07:11:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1210	822	`runtime_api`: improve request caching	{I9-optimisation}	t	f	\N	11	2022-05-18 09:52:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1211	45	Export child storage change notifications through RPC	{I5-enhancement}	t	f	\N	11	2022-05-18 07:56:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1212	823	bitfield-signing: use `fatality` for error-handling	{I4-refactor}	t	f	\N	11	2022-05-17 12:32:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1213	46	Timelock support for transactions	{I5-enhancement,I10-unconfirmed,T1-FRAME}	t	f	\N	11	2022-05-16 08:43:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1214	119	Allow iteration over contract storage	{I5-enhancement,D3-involved}	t	f	\N	11	2022-05-13 10:06:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1215	277	Standard scale for transaction priority	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-05-12 12:52:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1216	825	`bitfield-distribution`: use unbounded channels for own bitfields	{I9-optimisation}	t	f	\N	11	2022-05-12 10:05:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1217	826	Add support for hysteresis thresholds for benchmarks	{I5-enhancement}	t	f	\N	11	2022-05-12 09:40:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1218	828	Parathreads: Take II	{I6-meta}	t	f	\N	11	2022-05-11 00:09:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1219	829	runtime_api subsystem queues requests internally and likely does redundant work	{}	t	f	\N	11	2022-05-10 11:58:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1220	97	Make Trusted Teleporters Available in Runtime Metadata or Storage	{T6-XCM,I5-enhancement}	t	f	\N	11	2022-05-05 15:46:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1221	830	Investigate grandpa resource usage	{}	t	f	\N	11	2022-05-05 14:47:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1222	831	XCM Weight Trader grumbles	{T6-XCM}	t	f	\N	11	2022-05-05 13:38:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1223	48	☂ Fix flaky tests	{T10-tests,D0-easy}	t	f	\N	11	2022-04-29 10:25:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1224	1140	Custom DispatchClass	{}	t	f	\N	11	2022-04-27 23:44:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1225	49	Spawn multiple offchain workers per block	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-04-27 23:39:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1226	833	Make force-approve for approval voting work in all cases	{I3-annoyance}	t	f	\N	11	2022-04-26 15:17:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1227	50	Refactoring preparation: Move justifications out (GRANDPA and BEEFY)	{I4-refactor}	t	f	\N	11	2022-04-26 11:59:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1228	51	Refactoring analysis: dependencies	{I4-refactor}	t	f	\N	11	2022-04-26 11:57:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1229	52	Refactoring preparation: Break apart verification and import	{I4-refactor}	t	f	\N	11	2022-04-26 11:52:07+00	\N	2024-09-25 14:49:58.209927+00	\N
1230	532	Refactoring preparation: Break down/split Sync.	{I4-refactor}	t	f	\N	11	2022-04-26 11:45:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1231	53	Refactoring analysis: Analyse the usage of block numbers	{I4-refactor}	t	f	\N	11	2022-04-26 11:42:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1232	54	Refactoring preparation: Block centric storage	{I4-refactor}	t	f	\N	11	2022-04-26 11:40:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1233	55	Refactoring analysis: The separation of read and write into the database	{I4-refactor}	t	f	\N	11	2022-04-26 11:37:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1234	56	Refactoring analysis: Analyse current state of the database	{I4-refactor}	t	f	\N	11	2022-04-26 11:11:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1235	57	Refactoring analysis: Asynchronous runtime calls	{I9-optimisation,I4-refactor}	t	f	\N	11	2022-04-26 11:10:14+00	\N	2024-09-25 14:49:58.209927+00	\N
1236	58	Refactoring analysis: Executor prioritisation	{I9-optimisation,I4-refactor}	t	f	\N	11	2022-04-26 11:06:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1237	834	Per subsystem message handling time metrics	{}	t	f	\N	11	2022-04-25 11:50:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1238	835	Zombienet: Use backchannel to learn which candidates are malicious	{I5-enhancement}	t	f	\N	11	2022-04-25 07:02:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1239	120	Document how to build a dashboard for contracts	{T11-documentation,D1-medium}	t	f	\N	11	2022-04-23 08:07:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1240	59	Polkadot node warning "unexpected canonical chain state…"	{}	t	f	\N	11	2022-04-21 17:35:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1241	836	WeightTrader refund limitations	{T6-XCM}	t	f	\N	11	2022-04-21 10:46:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1242	837	Barrier should be able to deny certain XCMs from happening explicitly	{T6-XCM}	t	f	\N	11	2022-04-19 16:25:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1243	838	Message handling refactoring in network bridge	{I4-refactor}	t	f	\N	11	2022-04-19 06:38:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1244	839	xcmPallet reserve transfer should return back InvalidDest if parachain doesn't exist	{}	t	f	\N	11	2022-04-16 05:45:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1245	278	Vision: Redesign Event system	{I5-enhancement,I6-meta,T1-FRAME}	t	f	\N	11	2022-04-13 10:15:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1246	840	signal is terminated and empty on shutdown	{I3-annoyance}	t	f	\N	11	2022-04-13 08:34:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1247	841	Avoid immediately writing assignments and approvals to disk in approval-voting	{I9-optimisation}	t	f	\N	11	2022-04-13 00:36:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1248	842	Gossip-support: draw random seed out of SessionInfo instead of invoking BABE API	{I4-refactor}	t	f	\N	11	2022-04-12 23:37:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1249	843	test parachain to parathread downgrade	{}	t	f	\N	11	2022-04-11 14:40:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1250	844	XCM Filters don't allow filtering on destination	{T6-XCM}	t	f	\N	11	2022-04-11 14:29:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1251	845	Overseer UI tests are flaky	{T10-tests}	t	f	\N	11	2022-04-11 13:45:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1252	846	TransactFilter for allowing users to call parachain call on relaychain	{}	t	f	\N	11	2022-04-11 06:07:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1253	98	META: Moving the Treasury Off the Relay Chain	{I5-enhancement,I6-meta}	t	f	\N	11	2022-04-08 11:58:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1254	60	Light sync state needs a proper format	{}	t	f	\N	11	2022-04-07 11:38:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1255	847	Improvement: Allow flags on docker build	{}	t	f	\N	11	2022-04-06 12:44:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1256	848	Add a unit test for force-approve in approval-voting	{C1-mentor,T10-tests}	t	f	\N	11	2022-03-31 20:26:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1257	391	:open_umbrella: Small benchmarking issues	{T12-benchmarks,D0-easy}	t	f	\N	11	2022-03-30 16:39:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1258	279	`historical::offchain` is broken	{I2-bug,T1-FRAME}	t	f	\N	11	2022-03-25 17:58:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1259	850	Pending Rococo benchmarks	{}	t	f	\N	11	2022-03-22 18:41:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1260	851	Integration test for DB upgrades	{T10-tests}	t	f	\N	11	2022-03-21 22:00:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1261	280	Benchmarks for `pallet-session` are coupled with `pallet-staking`, but not all runtimes use both	{I4-refactor,T1-FRAME,D1-medium}	t	f	\N	11	2022-03-19 00:29:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1262	281	election-provider-multi-phase: Add extrinsic to challenge signed submissions	{C1-mentor,T1-FRAME,D1-medium}	t	f	\N	11	2022-03-16 11:35:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1263	392	Remove old benchmark code	{}	t	f	\N	11	2022-03-15 15:55:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1264	854	Histogram metric for collator-protocol indicating collation fetch times and failures	{I5-enhancement}	t	f	\N	11	2022-03-14 17:17:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1265	1141	Child bounty improvements	{C1-mentor,I5-enhancement,D0-easy,C2-good-first-issue}	t	f	\N	11	2022-03-14 03:56:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1266	855	META: Parachains Reading Storage of One Another	{I6-meta}	t	f	\N	11	2022-03-11 13:41:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1267	858	Runtime API Subsystem should not do version negotiation internally	{I4-refactor}	t	f	\N	11	2022-03-07 06:56:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1268	859	Tools or mechanisms to help debug improperly configured XCM modules/pallets	{T6-XCM}	t	f	\N	11	2022-03-03 12:18:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1269	860	flaky test: collator_side::advertise_and_send_collation	{T10-tests}	t	f	\N	11	2022-03-01 10:13:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1270	861	Revisit using the relay parent of a candidate for ordering in the dispute coordinator	{I1-security,I3-annoyance}	t	f	\N	11	2022-03-01 09:04:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1271	282	Directly stake staking rewards to some nominator, RewardDestination::AccountTryStaked<AccountId>	{I5-enhancement,T1-FRAME}	t	f	\N	11	2022-02-28 11:22:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1272	283	Vision: Easily verifiable key-less accounts	{I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2022-02-25 21:49:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1273	393	Benchmark Weight Assumptions	{I6-meta}	t	f	\N	11	2022-02-25 13:17:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1274	284	Incorrect unreserve destination when removing an anonymous proxy	{T1-FRAME}	t	f	\N	11	2022-02-21 17:36:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1275	863	Back and include multiple blocks at once for a single availability core	{I9-optimisation}	t	f	\N	11	2022-02-21 03:07:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1276	864	XCM: Make locking work with multiple assets	{T6-XCM}	t	f	\N	11	2022-02-20 15:32:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1277	866	Parity-db future enhancement for parachains	{I5-enhancement}	t	f	\N	11	2022-02-17 16:35:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1278	460	nomination-pools: Investigate adding joining pools	{D1-medium}	t	f	\N	11	2022-02-15 17:16:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1279	867	offchain multisig account support	{}	t	f	\N	11	2022-02-15 02:11:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1280	868	Figure out a way for chains to advertise their weight fee schedule	{T6-XCM}	t	f	\N	11	2022-02-11 18:15:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1281	869	Enable the `improved_panic_error_reporting` feature in `sp-io` for our runtimes in a few releases	{T0-node,I5-enhancement,T1-FRAME}	t	f	\N	11	2022-02-09 09:18:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1282	870	Keep Rococo's Runtime and Nodes Updated	{}	t	f	\N	11	2022-02-08 13:30:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1283	872	disputes: include a reason for an invalid vote	{I5-enhancement}	t	f	\N	11	2022-02-06 15:35:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1284	533	https://github.com/paritytech/substrate/pull/10688 doesn't take reserved nodes into account	{}	t	f	\N	11	2022-02-05 12:08:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1285	394	Weight info for `Offences::report_offence`	{I5-enhancement,D1-medium}	t	f	\N	11	2022-02-02 15:30:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1286	395	Automatic weights for `BABE` and `Grandpa`	{I5-enhancement,D2-substantial}	t	f	\N	11	2022-02-02 15:13:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1287	285	`#[must_use]` for benchmarking components	{C1-mentor,I5-enhancement,T1-FRAME,D0-easy}	t	f	\N	11	2022-01-31 11:04:23+00	\N	2024-09-25 14:49:58.209927+00	\N
1288	286	Rebalance Vote or Delegation in New Conviction Voting Pallet	{C1-mentor,T1-FRAME,D0-easy}	t	f	\N	11	2022-01-31 04:00:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1289	873	introduce fuzz based testing to the relay chain runtime	{}	t	f	\N	11	2022-01-27 18:22:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1290	61	Problem with subscriptions on parachain balances.	{I2-bug}	t	f	\N	11	2022-01-27 14:17:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1291	534	Sync 2.0	{I4-refactor,D2-substantial}	t	f	\N	11	2022-01-26 23:25:23+00	\N	2024-09-25 14:49:58.209927+00	\N
1292	396	Benchmarking end to end transaction throughput performance	{I10-unconfirmed}	t	f	\N	11	2022-01-24 08:29:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1293	875	Integrate ChainSelectionSubsystem fork-choice into Substrate's fork-choice	{I4-refactor}	t	f	\N	11	2022-01-22 23:45:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1294	876	XCM reserve transfer cannot transfer max amount on Statemine	{T6-XCM}	t	f	\N	11	2022-01-22 22:22:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1295	877	Parachain Slot Extension Story	{}	t	f	\N	11	2022-01-21 03:55:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1296	288	Vision: Improve Developer Experience with better Config Traits	{C1-mentor,I4-refactor,T1-FRAME,D1-medium}	t	f	\N	11	2022-01-18 05:47:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1297	107	Document Cross Chain Asset Interactions with Asset Hub	{T6-XCM,T11-documentation,T14-system_parachains}	t	f	\N	11	2022-01-17 15:57:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1298	2344	Merge PVF execution into Substrate repo?	{}	t	f	\N	11	2022-01-17 14:06:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1299	879	Re-evaluate usage of block with largest height for chain queries	{I2-bug}	t	f	\N	11	2022-01-17 13:00:31+00	\N	2024-09-25 14:49:58.209927+00	\N
1300	880	PVF host: Investigate how to better launch worker processes	{}	t	f	\N	11	2022-01-14 14:30:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1301	401	bench/cli: extend `--extrinsic` name filtering	{I5-enhancement,D0-easy}	t	f	\N	11	2022-01-14 13:22:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1302	883	Reasons why next, please help	{}	t	f	\N	11	2022-01-12 05:02:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1303	400	frame/benchmarking: baseline weights independent of complexity params	{T10-tests,D0-easy}	t	f	\N	11	2022-01-11 18:31:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1304	289	Document `OriginCaller`	{T1-FRAME,T11-documentation}	t	f	\N	11	2022-01-11 10:51:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1305	884	parachain::pvf not starting correctly	{}	t	f	\N	11	2022-01-09 02:19:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1306	290	Investigate better types for max len of bounded storage items	{I4-refactor,T1-FRAME}	t	f	\N	11	2022-01-07 23:05:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1307	885	Allow parachains to place extra data in the availability store	{I5-enhancement}	t	f	\N	11	2022-01-05 19:54:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1308	62	The road to the native runtime free world	{I6-meta}	t	f	\N	11	2022-01-04 09:31:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1309	887	QueryResponse::ExecutionResult should be able to return transact call's DispatchError	{T6-XCM}	t	f	\N	11	2021-12-28 11:06:24+00	\N	2024-09-25 14:49:58.209927+00	\N
1310	889	disputes: remove `DISPUTE_WINDOW` constant	{I4-refactor}	t	f	\N	11	2021-12-27 17:36:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1311	74	CollectCollationInfo should run on "unimported" state	{I5-enhancement}	t	f	\N	11	2021-12-22 12:18:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1312	890	Drop candidates with insufficient backing in runtime + drop node side check	{}	t	f	\N	11	2021-12-21 17:04:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1313	397	Benchmarking Roadmap 2022 (Tracking Issue)	{I6-meta}	t	f	\N	11	2021-12-21 15:42:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1314	891	[inherent_data] Avoid some repeated storage lookups in 	{I9-optimisation}	t	f	\N	11	2021-12-15 10:31:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1315	893	Other: Essential task failed	{}	t	f	\N	11	2021-12-13 10:42:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1316	894	Investigate predicting weight of enacting candidates via bitfields	{}	t	f	\N	11	2021-12-11 01:02:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1317	895	Add upper bound to bitfield iterations in the node	{}	t	f	\N	11	2021-12-11 00:59:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1318	896	Consider tracking candidate enactment weight in a weight only function	{}	t	f	\N	11	2021-12-11 00:52:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1319	897	Optimize reanchor	{T6-XCM}	t	f	\N	11	2021-12-08 11:42:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1320	292	Vision: Allow a runtime upgrade to a code larger than maximum block size.	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-12-03 23:16:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1321	899	Configure UmpSink to allow Parachains to execute messages on Polkadot	{T6-XCM}	t	f	\N	11	2021-12-03 15:24:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1322	293	Rewrite `reduce.rs`	{I4-refactor,T1-FRAME}	t	f	\N	11	2021-12-03 14:49:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1323	294	Allow to pass a bound on StorageCountedMap::remove_all (similarly to StorageMap::removal_all)	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-12-03 04:15:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1324	900	XCM Generics Benchmarks Leftovers (TODO)	{T6-XCM}	t	f	\N	11	2021-12-01 05:03:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1325	901	Avoid trap asset amount below a threshold	{T6-XCM}	t	f	\N	11	2021-11-30 23:00:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1326	295	FRAME Benchmarking CLI Flag for BenchmarkError Behavior	{C1-mentor,T1-FRAME,T12-benchmarks,D0-easy}	t	f	\N	11	2021-11-30 16:55:14+00	\N	2024-09-25 14:49:58.209927+00	\N
1327	902	`BenchBuilder` build should return `Result<Bench<T>, Bench<T>>`	{}	t	f	\N	11	2021-11-29 21:01:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1328	904	POV distribution: Fix guide	{T11-documentation}	t	f	\N	11	2021-11-29 11:17:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1329	905	dispute-distribution: Better name for `SendTask`	{}	t	f	\N	11	2021-11-29 10:52:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1330	906	dispute-coordinator: Improve test coverage some more	{}	t	f	\N	11	2021-11-29 10:31:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1331	907	Test false negative dispute spam	{}	t	f	\N	11	2021-11-23 16:24:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1332	296	Enforce migrations to be standalone scripts	{I6-meta,T1-FRAME}	t	f	\N	11	2021-11-18 16:38:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1333	75	Introduce new runtime api `GetParachainId`	{I5-enhancement}	t	f	\N	11	2021-11-18 12:57:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1334	908	Improve documentation for optimized network	{}	t	f	\N	11	2021-11-18 04:05:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1335	909	PVF validation host livelock	{I2-bug}	t	f	\N	11	2021-11-16 12:01:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1336	910	Preparation: Do not announce an approval assignment if the code is not prepared	{}	t	f	\N	11	2021-11-15 17:53:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1337	297	Governance Horizon	{I6-meta,T1-FRAME}	t	f	\N	11	2021-11-12 18:13:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1338	99	Pay Fees on Sending Side of Teleportation	{T6-XCM,I5-enhancement}	t	f	\N	11	2021-11-10 13:12:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1339	917	Explicit versioning of PVF execution environment	{}	t	f	\N	11	2021-11-03 12:37:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1340	121	contracts: XCM support	{T6-XCM,I5-enhancement,D3-involved}	t	f	\N	11	2021-11-01 18:12:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1341	298	De-/Re-constructable Call	{T1-FRAME,D1-medium}	t	f	\N	11	2021-11-01 10:27:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1342	919	raw definition of XCM AccountId hampers UX in js/apps	{T6-XCM}	t	f	\N	11	2021-10-31 11:17:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1343	299	Ease implementation of mock for pallets.	{T1-FRAME}	t	f	\N	11	2021-10-30 15:06:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1344	920	Figure out a good error reporting mechanism for XCM	{T6-XCM}	t	f	\N	11	2021-10-28 11:02:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1345	300	Feature Request: Proof of Work Signed Extension	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-10-25 12:52:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1346	922	xcm version auto discovery improvements	{T6-XCM}	t	f	\N	11	2021-10-24 11:18:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1347	923	Bug on including multisig transactions into the Polkadot blockchain v0.9.11 and v0.9.12	{}	t	f	\N	11	2021-10-24 10:14:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1348	63	Remove post runtime digests in the runtime before executing a block	{I4-refactor,I5-enhancement}	t	f	\N	11	2021-10-21 14:15:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1349	924	Tests for the XCMP queue in Cumulus.	{T6-XCM}	t	f	\N	11	2021-10-21 08:52:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1350	925	XCM Horizon	{T6-XCM,I6-meta}	t	f	\N	11	2021-10-21 08:34:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1351	926	`WeightToFeePolynomial` should have `calc` split off from it by implying a `Convert<Weight, Balance>`.	{I4-refactor}	t	f	\N	11	2021-10-21 08:27:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1352	301	Add a way to share readable data between benchmarks	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-10-20 20:57:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1353	928	Session key backup for minimal downtime migration - outage	{}	t	f	\N	11	2021-10-14 08:57:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1354	929	Optimize Backing Networking	{I9-optimisation}	t	f	\N	11	2021-10-11 14:38:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1355	64	After runtime upgrade, Runtime API calls use new code with unmigrated storage	{I2-bug,T1-FRAME}	t	f	\N	11	2021-10-11 10:31:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1356	930	Polkadot App can't  Downward Transfers   	{}	t	f	\N	11	2021-10-11 10:02:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1357	931	A suggestion on improving the bid reserving mechanism	{}	t	f	\N	11	2021-10-09 14:24:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1358	303	Vision: Improve Usage of Constants in Pallets	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-10-07 22:55:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1359	932	receive message: "Dispute coordinator confirmation lost"	{}	t	f	\N	11	2021-10-05 23:10:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1360	933	[subsystem] improve parallelization by consuming messages inbetween overseer signals in parallel	{I4-refactor}	t	f	\N	11	2021-10-05 14:54:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1361	935	Defer dispute handling until `CandidateReceipt` is observed	{I3-annoyance}	t	f	\N	11	2021-10-04 15:01:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1362	937	give `BackedCandidate` field ordering guarantees	{I3-annoyance,I4-refactor}	t	f	\N	11	2021-10-02 12:05:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1363	304	Vision: Delegate Fees and Deposits to Another User	{I5-enhancement,T1-FRAME,D2-substantial}	t	f	\N	11	2021-09-29 03:15:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1364	938	Consider extracting validation code (aka PVF) handling from paras into a separate module	{I4-refactor}	t	f	\N	11	2021-09-28 13:59:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1365	939	[node/refactor] setup code complexity is very high	{}	t	f	\N	11	2021-09-28 12:33:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1366	940	Request Support for BLS12 based signature verification	{}	t	f	\N	11	2021-09-27 07:06:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1367	941	Add Bags List `put_in_front_of` to relevant proxies	{}	t	f	\N	11	2021-09-25 02:23:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1368	942	Generate a new docker injected image with a client built with all features	{}	t	f	\N	11	2021-09-24 15:02:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1369	943	Re-enable connectivity warning	{}	t	f	\N	11	2021-09-24 14:17:23+00	\N	2024-09-25 14:49:58.209927+00	\N
1370	944	Para initialization does not respect `validation_code_delay`	{}	t	f	\N	11	2021-09-23 21:40:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1371	305	Weight refunds for staking extrinsics potentially using `SortedListProvider`	{C1-mentor,T1-FRAME,D1-medium}	t	f	\N	11	2021-09-20 15:51:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1372	946	Test false negative disputes on Rococo	{}	t	f	\N	11	2021-09-17 14:53:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1373	947	Parachain not producing blocks, is stalling finality	{I2-bug}	t	f	\N	11	2021-09-16 13:37:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1374	949	Approval-voting: Automatically schedule wakeups for unapproved candidates to 'unstick' them	{I3-annoyance}	t	f	\N	11	2021-09-14 20:17:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1375	950	Parachain block skipped by validators on Kusama	{}	t	f	\N	11	2021-09-13 20:35:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1376	952	Leases in the Slots Pallet is Unbounded	{}	t	f	\N	11	2021-09-06 23:22:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1377	535	Node not syncing anymore after importing block in reverse order	{I10-unconfirmed}	t	f	\N	11	2021-09-03 18:20:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1378	954	Real weight for `DropAssets`.	{}	t	f	\N	11	2021-08-28 21:35:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1379	955	Version 0.9.8 error: Could not select version for requirement `crypto-mac =" ^ 0.7 "`	{}	t	f	\N	11	2021-08-26 15:08:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1380	76	Write test for state_subsribeRuntimeVersion	{T10-tests}	t	f	\N	11	2021-08-26 09:02:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1381	77	CollectCollationInfo should use old runtime	{I5-enhancement}	t	f	\N	11	2021-08-24 21:36:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1382	956	Runtime Side: Remove `validation_code` runtime API	{}	t	f	\N	11	2021-08-23 15:06:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1383	2343	Node Side: Remove `validation_code` runtime API	{T0-node}	t	f	\N	11	2021-08-23 15:05:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1384	306	Vision: Ergonomic multi-block operations	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-08-19 17:32:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1385	957	Support XcmError to DispatchError conversion	{T6-XCM}	t	f	\N	11	2021-08-16 23:45:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1386	307	Support Unlocking Vested Balance Without Having Free Balance	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-08-13 13:17:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1387	461	Tracking Issue for multi-block election + dedicated election system parachain 	{I6-meta}	t	f	\N	11	2021-08-06 14:59:27+00	\N	2024-09-25 14:49:58.209927+00	\N
1388	309	Event improvment: independent from frame-system, stored in multiples values, ensure not in PoV	{T1-FRAME}	t	f	\N	11	2021-08-03 09:57:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1389	122	Wasm Contracts: Implement Code Merkleization	{I9-optimisation,I6-meta}	t	f	\N	11	2021-07-25 06:50:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1390	959	Optimize signature checks	{I9-optimisation,T1-FRAME}	t	f	\N	11	2021-07-14 14:46:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1391	961	Include `ValidatorIndex` in the dispute statement	{I4-refactor}	t	f	\N	11	2021-07-10 03:51:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1392	962	Parachain ValidationFunctionApplied different relay block than Relay	{I2-bug}	t	f	\N	11	2021-07-09 08:55:31+00	\N	2024-09-25 14:49:58.209927+00	\N
1393	963	Collators unconditionally queue up collation requests	{I2-bug}	t	f	\N	11	2021-07-07 17:06:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1394	2342	Validation host is not amenable for thorough testing	{I4-refactor,T10-tests}	t	f	\N	11	2021-07-06 09:49:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1395	964	Monitor connectivity to validators	{I5-enhancement}	t	f	\N	11	2021-07-05 10:43:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1396	311	Emit better error messages when user forgets to import a pallet part and tries to use a type defined by the part	{I10-unconfirmed}	t	f	\N	11	2021-07-01 20:06:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1397	312	Vision: Execute a hook after inherent but before transactions	{C1-mentor,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2021-06-28 01:53:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1398	313	How to check for asset existence?	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-06-24 09:19:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1399	536	Tracking issue for QUIC support	{}	t	f	\N	11	2021-06-21 12:57:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1400	967	runtime upgrade: Methods to avoid ever including parachain code in critical-path data	{I9-optimisation}	t	f	\N	11	2021-06-19 02:10:40+00	\N	2024-09-25 14:49:58.209927+00	\N
1401	968	Torrent-style fetching for PoVs: high-level	{I9-optimisation}	t	f	\N	11	2021-06-18 18:35:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1402	314	[Deprecation] Explore deprecating the staking `chill` extrinsic	{C1-mentor,T1-FRAME,T13-deprecation}	t	f	\N	11	2021-06-15 04:53:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1403	315	Targeted Transaction Payment (fixed cost per tx)	{T1-FRAME,T11-documentation}	t	f	\N	11	2021-06-14 08:54:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1404	316	Use `CountedMap` instead of Asset Witness Data	{T1-FRAME}	t	f	\N	11	2021-06-10 01:13:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1405	537	notifications_back_pressure test is flaky	{I2-bug}	t	f	\N	11	2021-06-08 16:33:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1406	969	Ability to query correct Xcm destination weights	{T6-XCM,I5-enhancement}	t	f	\N	11	2021-06-07 17:58:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1407	317	Add Memory Information to Runtime Benchmarks	{T1-FRAME}	t	f	\N	11	2021-06-03 16:26:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1408	319	Improve OnUnbalance trait for better information on the unbalanced amounts	{T1-FRAME}	t	f	\N	11	2021-05-19 16:54:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1409	78	Fetch parachain runtime code from the relay chain	{I5-enhancement}	t	f	\N	11	2021-05-14 11:17:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1410	321	StorageNMap follow up improvments	{T1-FRAME}	t	f	\N	11	2021-05-14 09:44:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1411	971	Get parachain runtime/code upgrades off chain	{I9-optimisation,I5-enhancement,I6-meta}	t	f	\N	11	2021-05-05 09:03:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1412	80	Take compressed PoV size into account while building a block	{I5-enhancement}	t	f	\N	11	2021-05-03 14:26:38+00	\N	2024-09-25 14:49:58.209927+00	\N
1413	322	Allow Democracy to Support Assets	{T1-FRAME}	t	f	\N	11	2021-04-30 17:37:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1414	462	Ensure saved offchain solution matches creation snapshop	{I2-bug}	t	f	\N	11	2021-04-29 14:04:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1415	398	PoV Benchmarking Tracking Issue	{I6-meta}	t	f	\N	11	2021-04-21 18:35:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1416	463	Generalize session-related traits for different type of session management without buffering	{I4-refactor}	t	f	\N	11	2021-04-21 12:47:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1417	323	[FRAME Core] Remove `without_storage_info` on pallets	{T1-FRAME}	t	f	\N	11	2021-04-16 14:06:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1418	2341	PVF validation host: hook up heads up signal	{I9-optimisation}	t	f	\N	11	2021-04-09 10:17:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1419	973	PVF validation host: pull not push PVFs	{I9-optimisation}	t	f	\N	11	2021-04-09 10:15:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1420	324	`PalletId` should be hardcoded into Pallet, not exposed as Config	{C1-mentor,I10-unconfirmed,D2-substantial}	t	f	\N	11	2021-04-09 09:58:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1421	538	Implement proper notification substreams shutdown	{I2-bug,D2-substantial}	t	f	\N	11	2021-04-05 12:07:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1422	539	Adding a node with `add_to_peers_set` will remove it right after it has 0 reputation	{I2-bug}	t	f	\N	11	2021-04-05 11:57:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1423	974	Create a Macro for Generating MultiLocations with Arbitrary Number of Junctions	{}	t	f	\N	11	2021-03-29 11:58:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1424	540	Addresses added using `add_known_address` are never cleaned up	{I2-bug}	t	f	\N	11	2021-03-26 15:55:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1425	326	Initialize New Accounts with Nonce Equal to Block Number	{C1-mentor,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2021-03-25 16:16:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1426	327	Tokens Horizon	{I6-meta,T1-FRAME}	t	f	\N	11	2021-03-25 10:38:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1427	328	Vision: Storage Deposits to be Ergonomic and Automatic	{I5-enhancement,T1-FRAME}	t	f	\N	11	2021-03-24 09:31:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1428	329	`max_extrinsic` in `BlockWeight` limit per class should take into account `base_block`	{T1-FRAME}	t	f	\N	11	2021-03-23 12:40:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1429	330	Invalid pallet session/pallet staking flow: purge_keys can decrement consumer ref count on wrong controller.	{T1-FRAME}	t	f	\N	11	2021-03-22 18:24:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1430	331	For weight: we should count the number of `sp_io::next_key` calls, and benchmark its cost correctly, similarly to reads and writes.	{T1-FRAME,D1-medium}	t	f	\N	11	2021-03-15 16:30:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1431	332	Consider removing suppressed and submitted_in from Nominations 	{A2-stale,T1-FRAME,D0-easy}	t	f	\N	11	2021-03-12 13:51:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1432	333	Test for trace_spans generated by decl_module and pallet macros	{T1-FRAME}	t	f	\N	11	2021-03-10 13:42:14+00	\N	2024-09-25 14:49:58.209927+00	\N
1433	334	All error returned by `pallet` macro should have an error number linking to some full description.	{I5-enhancement,T1-FRAME,T11-documentation}	t	f	\N	11	2021-03-04 17:27:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1434	335	pallet balance `ensure_can_withdraw` can be invalid if provider is required	{I2-bug,T1-FRAME}	t	f	\N	11	2021-03-03 17:11:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1435	976	Request availability chunks from actual backers	{I5-enhancement}	t	f	\N	11	2021-02-23 18:51:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1436	336	Avoid burning tokens in pallet-staking and other runtime modules	{A2-stale,T1-FRAME}	t	f	\N	11	2021-02-23 12:23:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1437	81	Provide a tool for doing offline validation	{}	t	f	\N	11	2021-02-17 16:22:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1438	977	Ensure code upgrade delay is at least one session long.	{}	t	f	\N	11	2021-02-17 00:29:17+00	\N	2024-09-25 14:49:58.209927+00	\N
1439	978	Use a more typesafe approach for managing indexed data	{I4-refactor}	t	f	\N	11	2021-02-08 19:51:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1441	337	Inconsistent behaviour of `repatriate_reserved` after introducing account reference provider when ED is 0	{I2-bug,T1-FRAME}	t	f	\N	11	2021-01-27 05:46:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1442	541	"Severe Protocol Error" reported by nodes running older substrate/libp2p after portion of network updates	{I10-unconfirmed}	t	f	\N	11	2021-01-25 20:39:47+00	\N	2024-09-25 14:49:58.209927+00	\N
1443	83	Add relay parent into digest	{I5-enhancement}	t	f	\N	11	2021-01-21 16:00:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1444	979	Clean up the primitives	{I4-refactor}	t	f	\N	11	2021-01-21 12:20:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1445	65	Rebroadcast blocks before importing them to reduce the hop latency.	{I9-optimisation,I5-enhancement}	t	f	\N	11	2021-01-18 16:58:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1446	465	Multi-Block Sequential Phragmén	{I5-enhancement,I6-meta}	t	f	\N	11	2021-01-18 15:38:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1447	542	libp2p request-response compatibility	{I2-bug}	t	f	\N	11	2021-01-18 08:56:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1448	338	Vision: Support Migrating Encoded Calls	{T1-FRAME}	t	f	\N	11	2021-01-12 14:44:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1449	980	Batch chunk writes to av-store	{I9-optimisation}	t	f	\N	11	2021-01-12 10:32:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1450	981	Define a `BlockHash` newtype adjacent to `CandidateHash`	{}	t	f	\N	11	2021-01-06 08:06:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1451	982	Increase validator spread maximum from 16 to 24	{C1-mentor}	t	f	\N	11	2021-01-03 13:07:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1452	66	--unsafe-no-validate option to import-blocks	{I10-unconfirmed}	t	f	\N	11	2020-12-26 04:08:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1453	983	Hashing for Jaeger string tags may be expensive and should be done lazily.	{I9-optimisation}	t	f	\N	11	2020-12-20 23:48:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1454	466	Configurable compounding staking reward	{I5-enhancement}	t	f	\N	11	2020-12-18 07:39:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1455	543	Request-response protocols DoS attack resilience	{D1-medium}	t	f	\N	11	2020-12-17 12:17:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1456	467	Staking/session: Rename the interactions	{I5-enhancement}	t	f	\N	11	2020-12-16 20:11:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1457	468	pallet-staking: era duration is off by one block.	{I5-enhancement}	t	f	\N	11	2020-12-16 14:49:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1458	984	Rename all Polkadot node crates	{I4-refactor}	t	f	\N	11	2020-12-10 19:15:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1459	339	Update Lock amounts based on slashing. 	{C1-mentor,I5-enhancement,T1-FRAME}	t	f	\N	11	2020-12-07 13:24:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1460	544	Add a proper fuzzing test for the code in behaviour.rs	{D1-medium}	t	f	\N	11	2020-12-07 09:06:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1461	985	Allow subsystems to finish work before shutdown: availability recovery and approvals	{I4-refactor}	t	f	\N	11	2020-11-28 18:22:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1462	545	Ignore .local dns addresses from global DHT	{}	t	f	\N	11	2020-11-20 04:34:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1463	986	Registrar doesn't seem to check the validity of the genesis params	{}	t	f	\N	11	2020-11-19 17:00:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1464	340	Revert broken runtime updates 	{I5-enhancement,T1-FRAME,D3-involved}	t	f	\N	11	2020-11-19 09:53:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1465	546	Protocol description in sc_network/src/lib.rs is slightly outdated	{}	t	f	\N	11	2020-11-02 13:54:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1466	547	Roadmap for allowing browser-embedded nodes to connect to Substrate networks	{D3-involved}	t	f	\N	11	2020-10-30 10:05:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1467	469	set_controller should check if session keys are set and move refcounts if they are 	{I2-bug}	t	f	\N	11	2020-10-15 15:52:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1468	342	Substrate with Gas Metering and Gas Limit	{}	t	f	\N	11	2020-10-02 13:55:56+00	\N	2024-09-25 14:49:58.209927+00	\N
1469	343	Better `migration` API	{I5-enhancement,T1-FRAME,D2-substantial}	t	f	\N	11	2020-09-24 22:00:33+00	\N	2024-09-25 14:49:58.209927+00	\N
1470	399	Improve `on_initialize` weight calulcation	{}	t	f	\N	11	2020-09-24 20:47:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1471	345	Implement procedural macro for getting the required balance for a transaction	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-09-16 07:13:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1472	346	Benchmarking / Weight pipeline should use a single number type	{C1-mentor,T1-FRAME}	t	f	\N	11	2020-09-15 15:50:49+00	\N	2024-09-25 14:49:58.209927+00	\N
1473	548	Change the implementation of `set_authorized_peers` and `set_authorized_only` to not use reserved nodes	{I4-refactor}	t	f	\N	11	2020-09-11 13:36:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1474	348	Allow transaction payment from proxy target account	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-09-09 01:33:38+00	\N	2024-09-25 14:49:58.209927+00	\N
1475	549	Authority-discovery should transmit addresses of all validators to network's address book	{}	t	f	\N	11	2020-09-07 09:16:03+00	\N	2024-09-25 14:49:58.209927+00	\N
1476	550	client/network: Allow Kademlia queries to be prematurely finished	{I9-optimisation,D1-medium}	t	f	\N	11	2020-09-07 08:22:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1477	67	rpc_methods shoud not return non exposed rpc methods	{I5-enhancement}	t	f	\N	11	2020-09-04 02:56:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1478	470	Validator Damping Function	{I10-unconfirmed}	t	f	\N	11	2020-09-01 08:33:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1479	471	[NPoS] Deprecate Stash/Controller	{I9-optimisation}	t	f	\N	11	2020-08-20 15:17:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1480	472	Restrict validator change commission	{I5-enhancement}	t	f	\N	11	2020-08-20 03:04:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1481	84	Write tests for overwritten host functions	{T10-tests}	t	f	\N	11	2020-08-12 07:56:14+00	\N	2024-09-25 14:49:58.209927+00	\N
1482	551	Remove NetworkService::write_notification	{I3-annoyance,I6-meta}	t	f	\N	11	2020-07-29 11:31:55+00	\N	2024-09-25 14:49:58.209927+00	\N
1483	552	Decide of the reliability and ordering guarantees of notifications (and implement them)	{I3-annoyance}	t	f	\N	11	2020-07-29 11:20:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1484	349	Encode required origin for extrinsics in metadata	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-07-29 08:45:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1485	474	Implement MMS algorithm for npos-election	{I5-enhancement,I10-unconfirmed}	t	f	\N	11	2020-07-12 07:50:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1486	351	Bring back signature batch verification	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-07-09 11:43:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1487	989	Parachains low-level networking meta-issue	{I6-meta}	t	f	\N	11	2020-07-09 10:49:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1488	553	Protocol changes for transaction propagation	{D1-medium}	t	f	\N	11	2020-07-08 14:32:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1489	1144	Not possible to implement AtLeast32Bit for signed number	{C1-mentor,I4-refactor,D1-medium}	t	f	\N	11	2020-06-30 03:43:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1490	353	Improve Migration Support	{I5-enhancement,I6-meta,T1-FRAME}	t	f	\N	11	2020-06-23 09:09:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1491	354	Write a test to demonstrate multisig reentrancy attack	{T1-FRAME,T10-tests,D1-medium}	t	f	\N	11	2020-06-19 18:12:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1492	990	PVF determinism	{}	t	f	\N	11	2020-06-15 16:45:07+00	\N	2024-09-25 14:49:58.209927+00	\N
1493	355	Make Origin accessible in weight calculation	{A2-stale,I5-enhancement,T1-FRAME,D1-medium}	t	f	\N	11	2020-06-10 10:05:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1494	356	Track potential untracked removals in Offences	{I2-bug,T1-FRAME}	t	f	\N	11	2020-05-21 11:59:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1495	68	Make clear which RPC methods are safe/unsafe	{I5-enhancement}	t	f	\N	11	2020-05-05 15:55:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1496	555	Update the networkState RPC with the latest networking change	{I5-enhancement,D0-easy}	t	f	\N	11	2020-05-04 12:45:38+00	\N	2024-09-25 14:49:58.209927+00	\N
1497	357	Use `Verify::Signer` for the offchain `SigningTypes` trait definition	{C1-mentor,I4-refactor,T1-FRAME,D0-easy}	t	f	\N	11	2020-04-16 11:50:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1498	358	Runtime restriction of peers	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-04-08 12:41:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1499	557	sc_network::NetworkWorker::event_streams should be a bounded channel	{D2-substantial}	t	f	\N	11	2020-04-07 12:42:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1500	475	pallet-session: disabled validator is not disabled from the queued validator set.	{I2-bug}	t	f	\N	11	2020-04-06 13:32:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1501	558	Add alternatives to the system_networkState RPC query	{}	t	f	\N	11	2020-04-06 11:58:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1502	559	In sc-network, isolate accesses to client, txpool, finality proof builder, ... in separate tasks.	{I2-bug,I4-refactor}	t	f	\N	11	2020-03-27 12:04:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1503	359	Transient storage runtime host function	{I9-optimisation,T1-FRAME,D1-medium}	t	f	\N	11	2020-03-25 10:58:19+00	\N	2024-09-25 14:49:58.209927+00	\N
1504	360	Add `iter_first_keys()` to `StorageDoubleMap`	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-03-19 18:21:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1505	560	Networking metrics to add to Prometheus	{I5-enhancement}	t	f	\N	11	2020-03-12 11:38:48+00	\N	2024-09-25 14:49:58.209927+00	\N
1506	477	Scheduler for off-chain workers execution	{I5-enhancement}	t	f	\N	11	2020-03-10 16:56:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1507	561	Refuse incoming connections before we know a bit about the network	{I1-security}	t	f	\N	11	2020-03-06 14:08:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1508	562	Responsible Memory Usage	{}	t	f	\N	11	2020-03-02 14:00:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1509	563	Add an UDP listening endpoint to prove reachability	{I5-enhancement}	t	f	\N	11	2020-03-02 12:18:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1510	361	Compute more precise payout.	{I5-enhancement,T1-FRAME}	t	f	\N	11	2020-03-02 11:20:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1511	564	Verify that addresses reported by identify are correct before inserting them in the DHT	{I1-security}	t	f	\N	11	2020-02-13 17:11:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1512	69	[Feature request] pruning mode: "since"	{I5-enhancement,D1-medium}	t	f	\N	11	2020-02-06 15:58:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1513	565	Serialize the peerset state on disk and reload it at startup	{I5-enhancement,D1-medium}	t	f	\N	11	2020-01-28 16:29:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1514	363	Per-pallet child tries	{I4-refactor,T1-FRAME,D3-involved}	t	f	\N	11	2020-01-13 15:04:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1515	364	Identity: Remove registrar	{T1-FRAME}	t	f	\N	11	2020-01-06 10:46:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1516	365	Switch `ValidateUnsigned` over to `SignedExtension`	{A2-stale,C1-mentor,I4-refactor,I5-enhancement,T1-FRAME}	t	f	\N	11	2019-12-17 13:14:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1517	366	Vision: Upgrade code via delta. 	{I5-enhancement,T1-FRAME}	t	f	\N	11	2019-10-08 14:10:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1518	93	Add Recovery Options for Validators	{I5-enhancement}	t	f	\N	11	2019-09-04 10:13:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1519	369	"And gate" for EnsureOrigin	{C1-mentor,I5-enhancement,T1-FRAME,D0-easy}	t	f	\N	11	2019-07-08 15:08:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1520	370	VISION: Try..catch for substrate runtimes	{I5-enhancement,T1-FRAME}	t	f	\N	11	2019-06-30 15:57:10+00	\N	2024-09-25 14:49:58.209927+00	\N
1521	371	Fix the event topic list inefficiency	{I9-optimisation,T1-FRAME}	t	f	\N	11	2019-05-13 10:02:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1522	568	Gossip push-pull protocol	{I5-enhancement}	t	f	\N	11	2019-02-27 20:42:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1523	569	Sync: security review 	{I1-security,I6-meta}	t	f	\N	11	2019-02-20 11:42:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1524	570	Sync should support fetching and importing long forks	{I5-enhancement}	t	f	\N	11	2019-01-23 23:31:31+00	\N	2024-09-25 14:49:58.209927+00	\N
1525	373	dispatch_thunk and ext_ functions use different WASM return convention	{I4-refactor,T1-FRAME}	t	f	\N	11	2019-01-16 12:18:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1526	571	Extend network protocol with justification announcements	{I5-enhancement}	t	f	\N	11	2018-12-15 09:42:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1527	70	Report Aura Equivocations to runtime	{I1-security}	t	f	\N	11	2018-10-26 10:15:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1528	572	DoS proof sync protocol.	{I1-security}	t	f	\N	11	2018-10-08 09:42:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1529	573	CLI for disabling the gossip service	{I5-enhancement}	t	f	\N	11	2018-07-30 15:08:32+00	\N	2024-09-25 14:49:58.209927+00	\N
1530	374	Governance: Approval vote alternatives for referendums	{I5-enhancement,T1-FRAME}	t	f	\N	11	2018-03-12 11:41:36+00	\N	2024-09-25 14:49:58.209927+00	\N
1531	6251	Rehauling Coretime x Omninode x Template Guides	{docs}	t	f	\N	12	2024-09-23 12:25:01+00	\N	2024-09-25 14:49:58.209927+00	\N
1532	6176	Request: Stable Coins on Polkadot	{docs}	t	f	\N	12	2024-08-26 08:09:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1533	6168	Add info about Polkadot Fellowship Sub Treasury	{docs}	t	f	\N	12	2024-08-22 13:22:42+00	\N	2024-09-25 14:49:58.209927+00	\N
1534	6085	Wiki Update - Mega Issue	{docs,epic}	t	f	\N	12	2024-07-19 10:52:02+00	\N	2024-09-25 14:49:58.209927+00	\N
1535	5930	Learn JAM: use cases	{docs}	t	f	\N	12	2024-05-31 10:34:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1536	5928	Suggest using the omni-node 	{docs}	t	f	\N	12	2024-05-31 06:19:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1537	5893	Validator Guide - Updates	{docs}	t	f	\N	12	2024-05-15 11:33:39+00	\N	2024-09-25 14:49:58.209927+00	\N
1538	5884	Add a section on how to dry run transactions using Fork Locally feature on Polkadot JS UI	{docs}	t	f	\N	12	2024-05-08 14:57:59+00	\N	2024-09-25 14:49:58.209927+00	\N
1539	5830	Add User Guides/Stories - Asset Hub	{docs}	t	f	\N	12	2024-04-25 16:08:22+00	\N	2024-09-25 14:49:58.209927+00	\N
1540	5799	Update Build Section for Agile Coretime	{docs}	t	f	\N	12	2024-04-18 19:10:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1541	5795	Update XCM Pallet Docs - New Extrinsics / Changes	{"T0 - Enhancement",docs}	t	f	\N	12	2024-04-17 23:58:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1542	5793	Update Coretime Docs	{docs}	t	f	\N	12	2024-04-17 20:57:46+00	\N	2024-09-25 14:49:58.209927+00	\N
1543	5772	XCMP Intro and Description	{docs}	t	f	\N	12	2024-04-09 13:25:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1544	5636	Update Rollup Comparison	{docs}	t	f	\N	12	2024-02-27 19:21:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1545	5620	Update Parcahain Auction doc	{docs}	t	f	\N	12	2024-02-19 19:14:23+00	\N	2024-09-25 14:49:58.209927+00	\N
1546	5582	[Feature Request] : Add info on how voting for tech fellowship works 	{docs}	t	f	\N	12	2024-02-06 12:26:50+00	\N	2024-09-25 14:49:58.209927+00	\N
1547	5548	[Feature Request] Update Avalanche comparison	{docs}	t	f	\N	12	2024-01-29 00:36:26+00	\N	2024-09-25 14:49:58.209927+00	\N
1548	5434	Update Kappa Sigma Mu page	{docs}	t	f	\N	12	2023-12-18 14:28:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1549	5372	Secure Validator docs update	{docs}	t	f	\N	12	2023-11-24 11:34:11+00	\N	2024-09-25 14:49:58.209927+00	\N
1550	5333	(next runtime ugrade) Update various pages to take Paged Reward Payouts into consideration	{docs}	t	f	\N	12	2023-11-02 07:42:21+00	\N	2024-09-25 14:49:58.209927+00	\N
1551	5315	[Feature Request] : Update pure proxy tutorial video 	{docs}	t	f	\N	12	2023-10-28 14:15:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1552	5225	[Feature Request] Tooltip Functionality	{docs}	t	f	\N	12	2023-09-25 13:36:08+00	\N	2024-09-25 14:49:58.209927+00	\N
1553	5184	[Feature Request] : Elaborate on metadata and whats the use	{docs}	t	f	\N	12	2023-09-12 21:31:05+00	\N	2024-09-25 14:49:58.209927+00	\N
1554	5041	Archive Controller Accounts: CLI Part	{}	t	f	\N	12	2023-07-14 11:46:07+00	\N	2024-09-25 14:49:58.209927+00	\N
1555	4793	[Feature Request] Expand description of parachain lease extension using existing paraid	{docs}	t	f	\N	12	2023-05-15 09:08:04+00	\N	2024-09-25 14:49:58.209927+00	\N
1556	4651	[Feature Request]: Ansible setup for running polkadot validator	{"P3 - Nice to Have",docs}	t	f	\N	12	2023-04-02 10:53:45+00	\N	2024-09-25 14:49:58.209927+00	\N
1557	4589	[Feature Request] : Polkadot block architecture explanation	{"P3 - Nice to Have","K2 - Architecture",docs}	t	f	\N	12	2023-03-17 06:59:12+00	\N	2024-09-25 14:49:58.209927+00	\N
1558	4540	[Feature Request] : add polkadot JS API to submit a signed payload	{docs}	t	f	\N	12	2023-03-04 13:53:25+00	\N	2024-09-25 14:49:58.209927+00	\N
1559	4517	[Feature Request] Metadata Explorer Runtime Casing	{docs}	t	f	\N	12	2023-02-27 16:01:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1560	3853	MEGA: unified graphics	{"A1 - In Progress",docs,epic}	t	f	\N	12	2022-09-30 15:45:41+00	\N	2024-09-25 14:49:58.209927+00	\N
1561	3653	Polkadot Reference Hardware Follow Ups	{"A1 - In Progress"}	t	f	\N	12	2022-08-17 09:42:43+00	\N	2024-09-25 14:49:58.209927+00	\N
1562	3439	[Feature Request] : Expand node interaction page 	{docs}	t	f	\N	12	2022-06-26 12:59:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1563	3243	[Feature Request] Add ansible automation support for monitoring node	{"P2 - Sometime Soon","K7 - Maintain",docs}	t	f	\N	12	2022-04-23 17:08:35+00	\N	2024-09-25 14:49:58.209927+00	\N
1564	727	Requesting state does not have the request body described	{}	t	f	\N	13	2024-07-16 14:40:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1565	726	Add the metadata hash signed extension to the extrinsic definition	{}	t	f	\N	13	2024-07-01 09:51:06+00	\N	2024-09-25 14:49:58.209927+00	\N
1566	725	Definition 154 is mistaken	{}	t	f	\N	13	2024-06-22 20:19:34+00	\N	2024-09-25 14:49:58.209927+00	\N
1567	718	Investigate Correctness of invariant: Authority Set for GRANDPA and BEEFY justification are the same for all blocks	{}	t	f	\N	13	2024-01-29 09:31:09+00	\N	2024-09-25 14:49:58.209927+00	\N
1568	709	Runtime API differences 	{}	t	f	\N	13	2023-10-05 11:03:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1569	706	Populate `Last Updated` on each page	{}	t	f	\N	13	2023-09-28 07:10:53+00	\N	2024-09-25 14:49:58.209927+00	\N
1570	697	Upate Weights and Benchmarking sections	{}	t	f	\N	13	2023-09-04 12:03:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1571	668	Compact proof section	{}	t	f	\N	13	2023-07-10 14:44:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1572	660	The section about light clients should be completely removed	{}	t	f	\N	13	2023-06-15 11:29:14+00	\N	2024-09-25 14:49:58.209927+00	\N
1573	652	Identify protocol version should be `/polkadot`	{}	t	f	\N	13	2023-06-09 07:28:13+00	\N	2024-09-25 14:49:58.209927+00	\N
1574	651	Move the parachains-related networking to the right place	{}	t	f	\N	13	2023-06-07 09:31:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1575	648	Missing information regarding child tries	{}	t	f	\N	13	2023-06-07 08:57:16+00	\N	2024-09-25 14:49:58.209927+00	\N
1576	646	Runtime custom sections missing mention of `runtime_apis`	{}	t	f	\N	13	2023-05-25 10:21:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1577	645	Runtime API Spec: tracking issue	{}	t	f	\N	13	2023-05-12 17:02:29+00	\N	2024-09-25 14:49:58.209927+00	\N
1578	577	ext_storage_get_version_1 behavior w.r.t. child tries	{}	t	f	\N	13	2022-11-03 11:36:20+00	\N	2024-09-25 14:49:58.209927+00	\N
1579	575	Document writing/clear_prefix behavior w.r.t. child tries	{}	t	f	\N	13	2022-11-02 10:23:37+00	\N	2024-09-25 14:49:58.209927+00	\N
1580	560	Keep track of AnV progress	{work-in-progress}	t	f	\N	13	2022-10-14 10:21:23+00	\N	2024-09-25 14:49:58.209927+00	\N
1581	540	Corner cases about child tries are unexplained	{}	t	f	\N	13	2022-10-04 09:55:30+00	\N	2024-09-25 14:49:58.209927+00	\N
1582	538	Metadata_metadata doesn't return the SCALE-encoded metadata but the SCALE-encoded SCALE-encoded metadata	{}	t	f	\N	13	2022-10-02 08:43:15+00	\N	2024-09-25 14:49:58.209927+00	\N
1583	536	FFI types (after conversion from Rust types) do not match the WASM types in spec	{}	t	f	\N	13	2022-09-14 11:56:57+00	\N	2024-09-25 14:49:58.209927+00	\N
1584	263	Specify BABE Temporary Clock Adjustment	{specification}	t	f	\N	13	2020-08-17 14:03:18+00	\N	2024-09-25 14:49:58.209927+00	\N
1585	251	Benchmark the effect of calling ext native functions in wasm blobs written in rust	{review}	t	f	\N	13	2020-07-23 12:04:51+00	\N	2024-09-25 14:49:58.209927+00	\N
1586	245	Upgrade the high level Balance module spec in Polkadot Verification repo	{tasks}	t	f	\N	13	2020-07-16 14:31:52+00	\N	2024-09-25 14:49:58.209927+00	\N
1587	224	Test and spec the use of exported WASM memory for Kusama compatibility.	{specification}	t	f	\N	13	2020-06-16 14:28:00+00	\N	2024-09-25 14:49:58.209927+00	\N
1609	5840	Remove usage of libsecp256k1 in claims palllet	{I10-unconfirmed}	t	f	\N	11	2024-09-25 20:49:46+00	\N	2024-09-25 20:50:12.77497+00	\N
1608	5835	Parachain import fails with Storage root must match that calculated	{I2-bug,I10-unconfirmed}	t	f	\N	11	2024-09-25 15:35:54+00	\N	2024-09-25 15:36:20.920146+00	\N
1615	5659	[Tracker] [Nomination Pools] Enabling Opengov voting support for Nomination Pool members	{T8-polkadot}	f	f	24	11	2024-09-10 11:02:02+00	2024-09-11 09:43:32+00	2024-09-26 07:35:29.117671+00	\N
301	4859	Get rid of `libp2p` dependency in `sc-authority-discovery`	{T0-node,I4-refactor,C2-good-first-issue}	t	f	\N	11	2024-06-21 13:01:18+00	\N	2024-09-25 14:49:58.209927+00	\N
134	5714	bot bench: Allow passing feature flags	{}	f	f	\N	11	2024-09-13 08:44:29+00	2024-09-26 11:41:57+00	2024-09-25 14:49:58.209927+00	\N
251	5220	Benchmark network stack CPU usage 	{T10-tests}	t	f	\N	11	2024-08-02 12:09:28+00	\N	2024-09-25 14:49:58.209927+00	\N
1621	5844	Fix flaky zombienet tests `0005-parachains-disputes-past-session` 	{}	t	f	\N	11	2024-09-26 11:48:09+00	\N	2024-09-26 11:48:36.2483+00	\N
1624	6268	This page crashed	{docs}	f	f	\N	12	2024-09-26 13:20:31+00	2024-09-26 14:07:40+00	2024-09-26 13:20:56.835934+00	\N
667	2059	Followup HRMP issues after PR #1246	{}	t	f	221	11	2023-10-27 11:22:58+00	\N	2024-09-25 14:49:58.209927+00	\N
1633	5852	`Zombienet` flaky tests	{}	t	f	191	11	2024-09-26 17:56:06+00	\N	2024-09-26 17:56:33.49151+00	\N
1618	6267	Rename "Parachains" to "Rollups"	{docs}	t	f	\N	12	2024-09-26 10:50:57+00	\N	2024-09-26 10:51:22.826381+00	\N
281	5009	[NPoS] When pool contribution of a pool member goes below ED, it should be reaped.	{C1-mentor,D1-medium}	t	f	\N	11	2024-07-12 01:59:00+00	\N	2024-09-25 14:49:58.209927+00	\N
721	1617	Rewrite approval voting and approval distribution as a single subsystem	{I9-optimisation,I4-refactor}	f	f	\N	11	2023-09-18 16:53:32+00	2024-09-27 06:53:25+00	2024-09-25 14:49:58.209927+00	\N
184	5494	`fatxpool`: improve handling of limits in `submit_and_watch`.	{T0-node}	f	f	167	11	2024-08-27 07:05:31+00	2024-09-27 07:30:50+00	2024-09-25 14:49:58.209927+00	\N
1644	729	Missing definition for unsigned extrinsics	{}	t	f	\N	13	2024-09-27 08:20:57+00	\N	2024-09-27 08:21:23.655987+00	\N
1645	730	Missing formal definition of Metadata V15	{}	t	f	\N	13	2024-09-27 08:29:08+00	\N	2024-09-27 08:29:34.631655+00	\N
1648	5858	Remove usage of AccountKeyring	{I5-enhancement}	t	f	\N	11	2024-09-27 11:55:31+00	\N	2024-09-27 11:55:59.488049+00	\N
540	3097	XCM regression tests	{T6-XCM,C1-mentor,I5-enhancement,T10-tests,C2-good-first-issue}	t	f	\N	11	2024-01-29 01:07:54+00	\N	2024-09-25 14:49:58.209927+00	\N
1630	5848	Fix flaky zombienet tests `zombienet-polkadot-coretime-revenue`	{}	t	f	\N	11	2024-09-26 14:32:16+00	\N	2024-09-26 14:32:45.606149+00	\N
226	5334	Increase `max_pov_size` to 10MB	{}	t	f	\N	11	2024-08-13 08:05:44+00	\N	2024-09-25 14:49:58.209927+00	\N
1661	5862	Support updating the trie changes directly into the database	{}	t	f	\N	11	2024-09-29 14:20:49+00	\N	2024-09-29 14:21:15.237346+00	\N
\.


--
-- Data for Name: languages; Type: TABLE DATA; Schema: public; Owner: kudosadmin
--

COPY public.languages (id, slug, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: kudosadmin
--

COPY public.projects (id, name, slug, types, purposes, stack_levels, technologies, avatar, created_at, updated_at) FROM stdin;
6	Polkadot	polkadot	{platform}	{universal}	{protocol,messaging,runtime}	{typescript,rust}	https://avatars.githubusercontent.com/u/14176906?v=4	2024-09-25 14:49:58.209927+00	\N
7	Kudos Portal	kudos	{dApp}	{data}	{offchain,messaging}	{}	https://avatars.githubusercontent.com/u/148229984?v=4	2024-09-25 14:52:57.517867+00	\N
\.


--
-- Data for Name: repositories; Type: TABLE DATA; Schema: public; Owner: kudosadmin
--

COPY public.repositories (id, slug, name, url, language_slug, project_id, created_at, updated_at) FROM stdin;
11	Polkadot SDK	polkadot-sdk	https://github.com/paritytech/polkadot-sdk	rust	6	2024-09-25 14:49:58.209927+00	\N
12	Polkadot Wiki	polkadot-wiki	https://github.com/w3f/polkadot-wiki	javascript	6	2024-09-25 14:49:58.209927+00	\N
13	Polkadot Spec	polkadot-spec	https://github.com/w3f/polkadot-spec	tex	6	2024-09-25 14:49:58.209927+00	\N
14	portal	portal	https://github.com/kudos-ink/portal	typescript	7	2024-09-25 14:52:57.517867+00	\N
15	issues-api	issues-api	https://github.com/kudos-ink/issues-api	rust	7	2024-09-25 14:52:57.517867+00	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: kudosadmin
--

COPY public.users (id, username, created_at, updated_at, avatar) FROM stdin;
143	l0r1s	2024-09-25 20:45:43.281907+00	2024-09-29 22:57:14.611878+00	https://avatars.githubusercontent.com/u/45130584?v=4
146	lean-apple	2024-09-25 20:45:43.354113+00	2024-09-29 22:57:16.841189+00	https://avatars.githubusercontent.com/u/78718413?v=4
148	lecascyril	2024-09-25 20:45:43.403629+00	2024-09-29 22:57:18.164722+00	https://avatars.githubusercontent.com/u/45956179?v=4
150	lovelaced	2024-09-25 20:45:43.450999+00	2024-09-29 22:57:19.93686+00	https://avatars.githubusercontent.com/u/8581604?v=4
3	5kram	2024-09-25 20:45:39.479689+00	2024-09-29 22:55:18.216283+00	https://avatars.githubusercontent.com/u/57923074?v=4
5	A-mont	2024-09-25 20:45:39.531624+00	2024-09-29 22:55:19.773188+00	https://avatars.githubusercontent.com/u/111330447?v=4
8	AbsoluteVirtueXI	2024-09-25 20:45:39.604237+00	2024-09-29 22:55:22.288476+00	https://avatars.githubusercontent.com/u/64846435?v=4
10	adelarja	2024-09-25 20:45:39.655899+00	2024-09-29 22:55:24.053509+00	https://avatars.githubusercontent.com/u/14829753?v=4
12	Agusrodri	2024-09-25 20:45:39.70406+00	2024-09-29 22:55:25.525261+00	https://avatars.githubusercontent.com/u/71607254?v=4
14	al3mart	2024-09-25 20:45:39.764126+00	2024-09-29 22:55:27.109733+00	https://avatars.githubusercontent.com/u/11448715?v=4
17	AlexD10S	2024-09-25 20:45:39.873238+00	2024-09-29 22:55:31.127374+00	https://avatars.githubusercontent.com/u/15804380?v=4
19	aliciashortman	2024-09-25 20:45:39.930813+00	2024-09-29 22:55:32.663294+00	https://avatars.githubusercontent.com/u/136574170?v=4
21	amijoski	2024-09-25 20:45:39.983765+00	2024-09-29 22:55:33.96261+00	https://avatars.githubusercontent.com/u/100565079?v=4
23	andresilva	2024-09-25 20:45:40.068809+00	2024-09-29 22:55:35.861301+00	https://avatars.githubusercontent.com/u/123550?v=4
26	antonva	2024-09-25 20:45:40.142247+00	2024-09-29 22:55:38.182213+00	https://avatars.githubusercontent.com/u/1540222?v=4
28	arrudagates	2024-09-25 20:45:40.19004+00	2024-09-29 22:55:39.737569+00	https://avatars.githubusercontent.com/u/30242466?v=4
31	arturoBeccar	2024-09-25 20:45:40.257538+00	2024-09-29 22:55:42.728081+00	https://avatars.githubusercontent.com/u/107512933?v=4
33	asteroidb612	2024-09-25 20:45:40.303452+00	2024-09-29 22:55:44.09593+00	https://avatars.githubusercontent.com/u/1222638?v=4
35	augustocollado	2024-09-25 20:45:40.358814+00	2024-09-29 22:55:45.399231+00	https://avatars.githubusercontent.com/u/56117494?v=4
37	ayomidebajo	2024-09-25 20:45:40.413918+00	2024-09-29 22:55:46.985496+00	https://avatars.githubusercontent.com/u/54250291?v=4
40	belousm	2024-09-25 20:45:40.492622+00	2024-09-29 22:55:51.067289+00	https://avatars.githubusercontent.com/u/45608177?v=4
42	BenWhiteJam	2024-09-25 20:45:40.544076+00	2024-09-29 22:55:52.34251+00	https://avatars.githubusercontent.com/u/41975995?v=4
44	bhargavbh	2024-09-25 20:45:40.593049+00	2024-09-29 22:55:54.359752+00	https://avatars.githubusercontent.com/u/40268131?v=4
47	bogdanS98	2024-09-25 20:45:40.676875+00	2024-09-29 22:55:56.862499+00	https://avatars.githubusercontent.com/u/10613980?v=4
49	bredamatt	2024-09-25 20:45:40.731319+00	2024-09-29 22:55:58.607725+00	https://avatars.githubusercontent.com/u/28816406?v=4
51	cardotrejos	2024-09-25 20:45:40.782582+00	2024-09-29 22:55:59.869867+00	https://avatars.githubusercontent.com/u/8602086?v=4
54	ChmilevFA	2024-09-25 20:45:40.861516+00	2024-09-29 22:56:01.949502+00	https://avatars.githubusercontent.com/u/17650184?v=4
56	cisar2218	2024-09-25 20:45:40.91411+00	2024-09-29 22:56:03.922473+00	https://avatars.githubusercontent.com/u/69775422?v=4
59	cocoyoon	2024-09-25 20:45:40.993841+00	2024-09-29 22:56:06.433274+00	https://avatars.githubusercontent.com/u/46347738?v=4
61	conors-code	2024-09-25 20:45:41.047171+00	2024-09-29 22:56:07.977496+00	https://avatars.githubusercontent.com/u/10066294?v=4
64	d-moos	2024-09-25 20:45:41.128324+00	2024-09-29 22:56:10.145613+00	https://avatars.githubusercontent.com/u/14070689?v=4
66	dadepo	2024-09-25 20:45:41.187508+00	2024-09-29 22:56:11.669527+00	https://avatars.githubusercontent.com/u/272535?v=4
68	Dan-Davis-Parity	2024-09-25 20:45:41.242118+00	2024-09-29 22:56:13.288059+00	https://avatars.githubusercontent.com/u/102178918?v=4
70	davidmoradi	2024-09-25 20:45:41.295204+00	2024-09-29 22:56:14.920554+00	https://avatars.githubusercontent.com/u/10715679?v=4
73	DeluxeRaph	2024-09-25 20:45:41.367563+00	2024-09-29 22:56:17.198257+00	https://avatars.githubusercontent.com/u/100111587?v=4
75	doingcloudstuff	2024-09-25 20:45:41.413883+00	2024-09-29 22:56:18.555329+00	https://avatars.githubusercontent.com/u/91522498?v=4
77	driemworks	2024-09-25 20:45:41.461349+00	2024-09-29 22:56:20.082555+00	https://avatars.githubusercontent.com/u/17711620?v=4
80	dudo50	2024-09-25 20:45:41.537284+00	2024-09-29 22:56:22.641148+00	https://avatars.githubusercontent.com/u/55763425?v=4
82	ecuamobi	2024-09-25 20:45:41.586989+00	2024-09-29 22:56:24.029335+00	https://avatars.githubusercontent.com/u/6625907?v=4
85	ericmorel	2024-09-25 20:45:41.663374+00	2024-09-29 22:56:25.912888+00	https://avatars.githubusercontent.com/u/40758533?v=4
87	eskimor	2024-09-25 20:45:41.712579+00	2024-09-29 22:56:27.554409+00	https://avatars.githubusercontent.com/u/1527017?v=4
89	ewogg	2024-09-25 20:45:41.763484+00	2024-09-29 22:56:29.094506+00	https://avatars.githubusercontent.com/u/74825804?v=4
92	FaisalAl-Tameemi	2024-09-25 20:45:41.837267+00	2024-09-29 22:56:31.140864+00	https://avatars.githubusercontent.com/u/4079648?v=4
94	fedevi7a	2024-09-25 20:45:41.905833+00	2024-09-29 22:56:32.730993+00	https://avatars.githubusercontent.com/u/55572642?v=4
96	ffarall	2024-09-25 20:45:41.974291+00	2024-09-29 22:56:34.681823+00	https://avatars.githubusercontent.com/u/37149322?v=4
99	GabrielCamba	2024-09-25 20:45:42.047569+00	2024-09-29 22:56:36.793783+00	https://avatars.githubusercontent.com/u/27218623?v=4
101	gavinmbell	2024-09-25 20:45:42.101339+00	2024-09-29 22:56:38.952599+00	https://avatars.githubusercontent.com/u/1261591?v=4
103	gdnathan	2024-09-25 20:45:42.171242+00	2024-09-29 22:56:40.586172+00	https://avatars.githubusercontent.com/u/53536851?v=4
106	gianfra-t	2024-09-25 20:45:42.277722+00	2024-09-29 22:56:42.45649+00	https://avatars.githubusercontent.com/u/96739519?v=4
108	Gorzorg	2024-09-25 20:45:42.332957+00	2024-09-29 22:56:44.120348+00	https://avatars.githubusercontent.com/u/95505280?v=4
111	gupnik	2024-09-25 20:45:42.409269+00	2024-09-29 22:56:46.29309+00	https://avatars.githubusercontent.com/u/17176722?v=4
113	harrydt	2024-09-25 20:45:42.460379+00	2024-09-29 22:56:47.687235+00	https://avatars.githubusercontent.com/u/15040151?v=4
115	hbulgarini	2024-09-25 20:45:42.508801+00	2024-09-29 22:56:49.443809+00	https://avatars.githubusercontent.com/u/12089572?v=4
118	iggyweb3	2024-09-25 20:45:42.58931+00	2024-09-29 22:56:51.86949+00	https://avatars.githubusercontent.com/u/47970431?v=4
120	JacksonRMC	2024-09-25 20:45:42.635778+00	2024-09-29 22:56:53.437649+00	https://avatars.githubusercontent.com/u/26369948?v=4
122	Jalal-1	2024-09-25 20:45:42.689317+00	2024-09-29 22:56:54.894327+00	https://avatars.githubusercontent.com/u/104898604?v=4
125	jonasW3F	2024-09-25 20:45:42.79963+00	2024-09-29 22:57:00.721438+00	https://avatars.githubusercontent.com/u/67730419?v=4
127	josejuansanz	2024-09-25 20:45:42.848286+00	2024-09-29 22:57:02.07293+00	https://avatars.githubusercontent.com/u/3686923?v=4
129	joshuacheong	2024-09-25 20:45:42.911479+00	2024-09-29 22:57:03.932032+00	https://avatars.githubusercontent.com/u/13146403?v=4
131	jslusser	2024-09-25 20:45:42.9677+00	2024-09-29 22:57:05.457591+00	https://avatars.githubusercontent.com/u/25765178?v=4
134	JuaniRios	2024-09-25 20:45:43.049699+00	2024-09-29 22:57:07.476072+00	https://avatars.githubusercontent.com/u/54085674?v=4
136	kempy007	2024-09-25 20:45:43.100829+00	2024-09-29 22:57:08.779404+00	https://avatars.githubusercontent.com/u/13536174?v=4
139	kilogold	2024-09-25 20:45:43.173206+00	2024-09-29 22:57:10.988251+00	https://avatars.githubusercontent.com/u/1028926?v=4
141	kingjulio8238	2024-09-25 20:45:43.227236+00	2024-09-29 22:57:12.637068+00	https://avatars.githubusercontent.com/u/120517860?v=4
1	0xangelo	2024-09-25 20:45:39.417284+00	2024-09-29 22:55:16.444297+00	https://avatars.githubusercontent.com/u/12701614?v=4
2	0xLucca	2024-09-25 20:45:39.451241+00	2024-09-29 22:55:17.48555+00	https://avatars.githubusercontent.com/u/95830307?v=4
4	a-acer	2024-09-25 20:45:39.50785+00	2024-09-29 22:55:18.837321+00	https://avatars.githubusercontent.com/u/62796059?v=4
6	a-moreira	2024-09-25 20:45:39.556948+00	2024-09-29 22:55:20.332491+00	https://avatars.githubusercontent.com/u/48456867?v=4
7	aaronbassett	2024-09-25 20:45:39.580799+00	2024-09-29 22:55:21.041954+00	https://avatars.githubusercontent.com/u/97928?v=4
9	adambrzosko	2024-09-25 20:45:39.630816+00	2024-09-29 22:55:23.020039+00	https://avatars.githubusercontent.com/u/47273267?v=4
11	agrofrank	2024-09-25 20:45:39.680184+00	2024-09-29 22:55:24.803285+00	https://avatars.githubusercontent.com/u/120337436?v=4
13	Aideepakchaudhary	2024-09-25 20:45:39.736863+00	2024-09-29 22:55:26.136121+00	https://avatars.githubusercontent.com/u/54492415?v=4
15	AlexanderSequest	2024-09-25 20:45:39.801449+00	2024-09-29 22:55:28.612325+00	https://avatars.githubusercontent.com/u/109016217?v=4
16	AlexandraDumond	2024-09-25 20:45:39.834198+00	2024-09-29 22:55:29.457112+00	https://avatars.githubusercontent.com/u/104295528?v=4
18	AlfonsoCev	2024-09-25 20:45:39.898203+00	2024-09-29 22:55:31.947592+00	https://avatars.githubusercontent.com/u/42770418?v=4
20	AlistairStewart	2024-09-25 20:45:39.958125+00	2024-09-29 22:55:33.236366+00	https://avatars.githubusercontent.com/u/32751032?v=4
152	lrazovic	2024-09-25 20:45:43.503394+00	2024-09-29 22:57:21.264892+00	https://avatars.githubusercontent.com/u/4128940?v=4
154	MamdBS	2024-09-25 20:45:43.557671+00	2024-09-29 22:57:22.615028+00	https://avatars.githubusercontent.com/u/66074272?v=4
156	martacarslake	2024-09-25 20:45:43.609957+00	2024-09-29 22:57:24.150302+00	https://avatars.githubusercontent.com/u/104775479?v=4
158	mastermaxy	2024-09-25 20:45:43.661263+00	2024-09-29 22:57:25.468217+00	https://avatars.githubusercontent.com/u/76131118?v=4
161	MatteoPerona	2024-09-25 20:45:43.736776+00	2024-09-29 22:57:28.09626+00	https://avatars.githubusercontent.com/u/63029740?v=4
163	mauropatrone	2024-09-25 20:45:43.807662+00	2024-09-29 22:57:29.402645+00	https://avatars.githubusercontent.com/u/62117646?v=4
166	michaelhealyco	2024-09-25 20:45:43.882712+00	2024-09-29 22:57:31.477973+00	https://avatars.githubusercontent.com/u/17098949?v=4
168	mikhail-sakhnov	2024-09-25 20:45:43.938984+00	2024-09-29 22:57:32.867608+00	https://avatars.githubusercontent.com/u/1655681?v=4
170	muraca	2024-09-25 20:45:43.987245+00	2024-09-29 22:57:34.145799+00	https://avatars.githubusercontent.com/u/56828990?v=4
173	nhussein11	2024-09-25 20:45:44.073081+00	2024-09-29 22:57:37.442472+00	https://avatars.githubusercontent.com/u/80422357?v=4
175	niklabh	2024-09-25 20:45:44.126453+00	2024-09-29 22:57:38.99592+00	https://avatars.githubusercontent.com/u/874046?v=4
177	noah-foltz	2024-09-25 20:45:44.199237+00	2024-09-29 22:57:41.515903+00	https://avatars.githubusercontent.com/u/108011919?v=4
179	NZT48	2024-09-25 20:45:44.285402+00	2024-09-29 22:57:43.106649+00	https://avatars.githubusercontent.com/u/15042395?v=4
182	Overkillus	2024-09-25 20:45:44.363528+00	2024-09-29 22:57:45.179109+00	https://avatars.githubusercontent.com/u/25622759?v=4
184	pandres95	2024-09-25 20:45:44.421324+00	2024-09-29 22:57:46.803234+00	https://avatars.githubusercontent.com/u/2502577?v=4
186	paulhealy09	2024-09-25 20:45:44.48162+00	2024-09-29 22:57:48.314732+00	https://avatars.githubusercontent.com/u/79900894?v=4
188	pavelsupr	2024-09-25 20:45:44.534835+00	2024-09-29 22:57:49.632222+00	https://avatars.githubusercontent.com/u/52500720?v=4
191	pepoviola	2024-09-25 20:45:44.63891+00	2024-09-29 22:57:52.146755+00	https://avatars.githubusercontent.com/u/363911?v=4
193	peterwht	2024-09-25 20:45:44.69101+00	2024-09-29 22:57:53.442394+00	https://avatars.githubusercontent.com/u/23270067?v=4
196	pieri93	2024-09-25 20:45:44.772419+00	2024-09-29 22:57:55.742541+00	https://avatars.githubusercontent.com/u/98557340?v=4
198	pmikolajczyk41	2024-09-25 20:45:44.823604+00	2024-09-29 22:57:57.297342+00	https://avatars.githubusercontent.com/u/27450471?v=4
200	poppyseedDev	2024-09-25 20:45:44.892834+00	2024-09-29 22:57:58.656075+00	https://avatars.githubusercontent.com/u/30662672?v=4
203	psfblair	2024-09-25 20:45:44.968347+00	2024-09-29 22:58:01.197593+00	https://avatars.githubusercontent.com/u/176193?v=4
205	Retamogordo	2024-09-25 20:45:45.06318+00	2024-09-29 22:58:02.508425+00	https://avatars.githubusercontent.com/u/56763675?v=4
208	rossbulat	2024-09-25 20:45:45.16366+00	2024-09-29 22:58:05.170349+00	https://avatars.githubusercontent.com/u/13929023?v=4
210	rphmeier	2024-09-25 20:45:45.230925+00	2024-09-29 22:58:07.012392+00	https://avatars.githubusercontent.com/u/10121380?v=4
212	rymnc	2024-09-25 20:45:45.311929+00	2024-09-29 22:58:08.641777+00	https://avatars.githubusercontent.com/u/43716372?v=4
215	sam0x17	2024-09-25 20:45:45.393618+00	2024-09-29 22:58:10.82335+00	https://avatars.githubusercontent.com/u/1855021?v=4
217	sashagood	2024-09-25 20:45:45.459228+00	2024-09-29 22:58:12.501905+00	https://avatars.githubusercontent.com/u/414200?v=4
219	sebastianmontero	2024-09-25 20:45:45.546132+00	2024-09-29 22:58:14.244057+00	https://avatars.githubusercontent.com/u/13155714?v=4
222	serhanwbahar	2024-09-25 20:45:45.643693+00	2024-09-29 22:58:16.433779+00	https://avatars.githubusercontent.com/u/47040097?v=4
224	sherlockjjj2	2024-09-25 20:45:45.692247+00	2024-09-29 22:58:18.339744+00	https://avatars.githubusercontent.com/u/71900289?v=4
226	siratoure95	2024-09-25 20:45:45.74422+00	2024-09-29 22:58:19.743045+00	https://avatars.githubusercontent.com/u/59237514?v=4
229	smiasojed	2024-09-25 20:45:45.818857+00	2024-09-29 22:58:21.80279+00	https://avatars.githubusercontent.com/u/26868757?v=4
231	snowmead	2024-09-25 20:45:45.880748+00	2024-09-29 22:58:24.107193+00	https://avatars.githubusercontent.com/u/94772640?v=4
234	stojanov-igor	2024-09-25 20:45:45.948836+00	2024-09-29 22:58:26.734451+00	https://avatars.githubusercontent.com/u/83087510?v=4
236	sylvaincormier	2024-09-25 20:45:45.996142+00	2024-09-29 22:58:28.042667+00	https://avatars.githubusercontent.com/u/6019499?v=4
238	Szegoo	2024-09-25 20:45:46.043926+00	2024-09-29 22:58:29.380094+00	https://avatars.githubusercontent.com/u/73715684?v=4
241	tesol2y090	2024-09-25 20:45:46.116841+00	2024-09-29 22:58:32.025972+00	https://avatars.githubusercontent.com/u/30050561?v=4
243	thea-leake	2024-09-25 20:45:46.175037+00	2024-09-29 22:58:33.820435+00	https://avatars.githubusercontent.com/u/4999366?v=4
245	TomaszWaszczyk	2024-09-25 20:45:46.223463+00	2024-09-29 22:58:35.661399+00	https://avatars.githubusercontent.com/u/1605705?v=4
247	tompgn	2024-09-25 20:45:46.276678+00	2024-09-29 22:58:37.462139+00	https://avatars.githubusercontent.com/u/108454493?v=4
250	tuan-genetica	2024-09-25 20:45:46.36867+00	2024-09-29 22:58:39.543752+00	https://avatars.githubusercontent.com/u/58465172?v=4
252	unixftw	2024-09-25 20:45:46.41587+00	2024-09-29 22:58:40.850929+00	https://avatars.githubusercontent.com/u/92534615?v=4
255	valentinfernandez1	2024-09-25 20:45:46.494091+00	2024-09-29 22:58:42.997055+00	https://avatars.githubusercontent.com/u/33705477?v=4
257	vieira-giulia	2024-09-25 20:45:46.545953+00	2024-09-29 22:58:44.316515+00	https://avatars.githubusercontent.com/u/71223172?v=4
259	VinceCorsica	2024-09-25 20:45:46.592281+00	2024-09-29 22:58:45.756894+00	https://avatars.githubusercontent.com/u/83284972?v=4
261	vsiless	2024-09-25 20:45:46.654827+00	2024-09-29 22:58:47.234011+00	https://avatars.githubusercontent.com/u/7073929?v=4
264	WalquerX	2024-09-25 20:45:46.74158+00	2024-09-29 22:58:50.645073+00	https://avatars.githubusercontent.com/u/29116347?v=4
266	wentelteefje	2024-09-25 20:45:46.78948+00	2024-09-29 22:58:52.579027+00	https://avatars.githubusercontent.com/u/10713977?v=4
269	yerbolgmailcom	2024-09-25 20:45:46.865278+00	2024-09-29 22:58:54.542803+00	https://avatars.githubusercontent.com/u/493845?v=4
271	zdave	2024-09-25 20:45:46.910494+00	2024-09-29 22:58:55.894918+00	https://avatars.githubusercontent.com/u/2984308?v=4
22	AndreSequest	2024-09-25 20:45:40.04524+00	2024-09-29 22:55:34.699531+00	https://avatars.githubusercontent.com/u/109017220?v=4
24	Ank4n	2024-09-25 20:45:40.09457+00	2024-09-29 22:55:36.429493+00	https://avatars.githubusercontent.com/u/10196091?v=4
25	Anonyma	2024-09-25 20:45:40.119514+00	2024-09-29 22:55:37.373086+00	https://avatars.githubusercontent.com/u/44095730?v=4
27	arjanvaneersel	2024-09-25 20:45:40.166446+00	2024-09-29 22:55:38.937268+00	https://avatars.githubusercontent.com/u/5507851?v=4
29	art-santos	2024-09-25 20:45:40.211798+00	2024-09-29 22:55:40.320672+00	https://avatars.githubusercontent.com/u/74426110?v=4
30	arturgontijo	2024-09-25 20:45:40.235239+00	2024-09-29 22:55:41.513934+00	https://avatars.githubusercontent.com/u/15108323?v=4
32	asiniscalchi	2024-09-25 20:45:40.280944+00	2024-09-29 22:55:43.352938+00	https://avatars.githubusercontent.com/u/2387339?v=4
34	athei	2024-09-25 20:45:40.333344+00	2024-09-29 22:55:44.682678+00	https://avatars.githubusercontent.com/u/2580396?v=4
36	avemtech	2024-09-25 20:45:40.388841+00	2024-09-29 22:55:46.267524+00	https://avatars.githubusercontent.com/u/99745968?v=4
38	bee344	2024-09-25 20:45:40.44043+00	2024-09-29 22:55:48.655168+00	https://avatars.githubusercontent.com/u/74352651?v=4
39	beekay2706	2024-09-25 20:45:40.468372+00	2024-09-29 22:55:50.501675+00	https://avatars.githubusercontent.com/u/93442895?v=4
41	benjaminsalon	2024-09-25 20:45:40.518725+00	2024-09-29 22:55:51.629333+00	https://avatars.githubusercontent.com/u/85124277?v=4
43	bernardoaraujor	2024-09-25 20:45:40.567405+00	2024-09-29 22:55:53.129313+00	https://avatars.githubusercontent.com/u/9698228?v=4
45	bkchr	2024-09-25 20:45:40.620319+00	2024-09-29 22:55:55.321966+00	https://avatars.githubusercontent.com/u/5718007?v=4
46	BMateo	2024-09-25 20:45:40.64636+00	2024-09-29 22:55:56.13413+00	https://avatars.githubusercontent.com/u/88801537?v=4
48	BradleyOlson64	2024-09-25 20:45:40.704984+00	2024-09-29 22:55:57.879694+00	https://avatars.githubusercontent.com/u/34992650?v=4
50	brunopgalvao	2024-09-25 20:45:40.757197+00	2024-09-29 22:55:59.319124+00	https://avatars.githubusercontent.com/u/1091413?v=4
52	carloskiron	2024-09-25 20:45:40.805847+00	2024-09-29 22:56:00.61452+00	https://avatars.githubusercontent.com/u/16585651?v=4
53	chenda-w3f	2024-09-25 20:45:40.836136+00	2024-09-29 22:56:01.20245+00	https://avatars.githubusercontent.com/u/138482397?v=4
55	chrisli30	2024-09-25 20:45:40.887673+00	2024-09-29 22:56:02.898368+00	https://avatars.githubusercontent.com/u/2616844?v=4
57	CJ13th	2024-09-25 20:45:40.943588+00	2024-09-29 22:56:04.483266+00	https://avatars.githubusercontent.com/u/48095175?v=4
58	coax1d	2024-09-25 20:45:40.96765+00	2024-09-29 22:56:05.648329+00	https://avatars.githubusercontent.com/u/22990920?v=4
60	cole-rose	2024-09-25 20:45:41.024995+00	2024-09-29 22:56:07.166568+00	https://avatars.githubusercontent.com/u/36212684?v=4
62	Cooksey99	2024-09-25 20:45:41.074179+00	2024-09-29 22:56:08.710237+00	https://avatars.githubusercontent.com/u/48497087?v=4
63	CrackTheCode016	2024-09-25 20:45:41.09869+00	2024-09-29 22:56:09.51171+00	https://avatars.githubusercontent.com/u/26698074?v=4
65	Daanvdplas	2024-09-25 20:45:41.15921+00	2024-09-29 22:56:10.869365+00	https://avatars.githubusercontent.com/u/93204684?v=4
67	DagieDee	2024-09-25 20:45:41.216535+00	2024-09-29 22:56:12.603952+00	https://avatars.githubusercontent.com/u/106725624?v=4
69	DanEscher98	2024-09-25 20:45:41.266092+00	2024-09-29 22:56:14.284082+00	https://avatars.githubusercontent.com/u/54251104?v=4
71	decentration	2024-09-25 20:45:41.318161+00	2024-09-29 22:56:15.653401+00	https://avatars.githubusercontent.com/u/45230082?v=4
72	deepto98	2024-09-25 20:45:41.342995+00	2024-09-29 22:56:16.466305+00	https://avatars.githubusercontent.com/u/91651033?v=4
74	dheeraj07	2024-09-25 20:45:41.39117+00	2024-09-29 22:56:17.77999+00	https://avatars.githubusercontent.com/u/22843503?v=4
76	DoubleOTheven	2024-09-25 20:45:41.439298+00	2024-09-29 22:56:19.126069+00	https://avatars.githubusercontent.com/u/2101499?v=4
78	drskalman	2024-09-25 20:45:41.485146+00	2024-09-29 22:56:20.800984+00	https://avatars.githubusercontent.com/u/35698397?v=4
79	DrW3RK	2024-09-25 20:45:41.511127+00	2024-09-29 22:56:21.905149+00	https://avatars.githubusercontent.com/u/86818441?v=4
81	ebma	2024-09-25 20:45:41.563303+00	2024-09-29 22:56:23.31399+00	https://avatars.githubusercontent.com/u/6690623?v=4
83	elv-nate	2024-09-25 20:45:41.612888+00	2024-09-29 22:56:24.594535+00	https://avatars.githubusercontent.com/u/109548806?v=4
84	epipheus	2024-09-25 20:45:41.637735+00	2024-09-29 22:56:25.336169+00	https://avatars.githubusercontent.com/u/349151?v=4
86	ernestosperanza	2024-09-25 20:45:41.688393+00	2024-09-29 22:56:26.966843+00	https://avatars.githubusercontent.com/u/29267672?v=4
88	evilrobot-01	2024-09-25 20:45:41.738173+00	2024-09-29 22:56:28.304065+00	https://avatars.githubusercontent.com/u/60948618?v=4
90	ezegolub	2024-09-25 20:45:41.788296+00	2024-09-29 22:56:29.809999+00	https://avatars.githubusercontent.com/u/1199769?v=4
91	f-gate	2024-09-25 20:45:41.813038+00	2024-09-29 22:56:30.356128+00	https://avatars.githubusercontent.com/u/42411328?v=4
93	fbielejec	2024-09-25 20:45:41.86489+00	2024-09-29 22:56:31.796576+00	https://avatars.githubusercontent.com/u/468572?v=4
95	feliam	2024-09-25 20:45:41.951459+00	2024-09-29 22:56:33.747958+00	https://avatars.githubusercontent.com/u/1017522?v=4
97	franciscoaguirre	2024-09-25 20:45:41.998318+00	2024-09-29 22:56:35.50882+00	https://avatars.githubusercontent.com/u/4390772?v=4
98	freespirit	2024-09-25 20:45:42.023136+00	2024-09-29 22:56:36.240811+00	https://avatars.githubusercontent.com/u/222401?v=4
100	gabriele-0201	2024-09-25 20:45:42.072216+00	2024-09-29 22:56:38.207326+00	https://avatars.githubusercontent.com/u/79002163?v=4
102	gavofyork	2024-09-25 20:45:42.136876+00	2024-09-29 22:56:39.800649+00	https://avatars.githubusercontent.com/u/138296?v=4
104	gfox1	2024-09-25 20:45:42.199788+00	2024-09-29 22:56:41.147203+00	https://avatars.githubusercontent.com/u/82609877?v=4
105	ggwpez	2024-09-25 20:45:42.243523+00	2024-09-29 22:56:41.868481+00	https://avatars.githubusercontent.com/u/10380170?v=4
107	girazoki	2024-09-25 20:45:42.30411+00	2024-09-29 22:56:43.427556+00	https://avatars.githubusercontent.com/u/18615930?v=4
109	gpestana	2024-09-25 20:45:42.360525+00	2024-09-29 22:56:44.894789+00	https://avatars.githubusercontent.com/u/1398860?v=4
110	guillermoap	2024-09-25 20:45:42.384878+00	2024-09-29 22:56:45.550364+00	https://avatars.githubusercontent.com/u/26125246?v=4
112	happyhackerbird	2024-09-25 20:45:42.434799+00	2024-09-29 22:56:47.031239+00	https://avatars.githubusercontent.com/u/66886792?v=4
114	hatcheryllc	2024-09-25 20:45:42.484491+00	2024-09-29 22:56:48.865863+00	https://avatars.githubusercontent.com/u/138341299?v=4
116	helixstreet	2024-09-25 20:45:42.539628+00	2024-09-29 22:56:50.387626+00	https://avatars.githubusercontent.com/u/53312868?v=4
117	hummusonrails	2024-09-25 20:45:42.56499+00	2024-09-29 22:56:51.096925+00	https://avatars.githubusercontent.com/u/13892277?v=4
119	ipapandinas	2024-09-25 20:45:42.612191+00	2024-09-29 22:56:52.605205+00	https://avatars.githubusercontent.com/u/26460174?v=4
121	jakerumbles	2024-09-25 20:45:42.66006+00	2024-09-29 22:56:54.164431+00	https://avatars.githubusercontent.com/u/25042987?v=4
123	javiermatias	2024-09-25 20:45:42.721861+00	2024-09-29 22:56:55.563138+00	https://avatars.githubusercontent.com/u/12036330?v=4
124	jfellman	2024-09-25 20:45:42.757494+00	2024-09-29 22:57:00.131087+00	https://avatars.githubusercontent.com/u/14809664?v=4
126	Jonathas-Conceicao	2024-09-25 20:45:42.823129+00	2024-09-29 22:57:01.46601+00	https://avatars.githubusercontent.com/u/15980682?v=4
128	JoshOrndorff	2024-09-25 20:45:42.87443+00	2024-09-29 22:57:03.114395+00	https://avatars.githubusercontent.com/u/2915325?v=4
130	jsidorenko	2024-09-25 20:45:42.943711+00	2024-09-29 22:57:04.904548+00	https://avatars.githubusercontent.com/u/5252494?v=4
132	jtfirek	2024-09-25 20:45:42.998605+00	2024-09-29 22:57:06.175581+00	https://avatars.githubusercontent.com/u/106350168?v=4
133	juangirini	2024-09-25 20:45:43.024638+00	2024-09-29 22:57:06.742793+00	https://avatars.githubusercontent.com/u/3775927?v=4
135	kayabaNerve	2024-09-25 20:45:43.074648+00	2024-09-29 22:57:08.066407+00	https://avatars.githubusercontent.com/u/25259837?v=4
137	kianenigma	2024-09-25 20:45:43.122828+00	2024-09-29 22:57:09.524632+00	https://avatars.githubusercontent.com/u/5588131?v=4
138	kilian1103	2024-09-25 20:45:43.145405+00	2024-09-29 22:57:10.267432+00	https://avatars.githubusercontent.com/u/52182004?v=4
140	King-Charming	2024-09-25 20:45:43.201819+00	2024-09-29 22:57:12.045749+00	https://avatars.githubusercontent.com/u/93770531?v=4
142	kratico	2024-09-25 20:45:43.254243+00	2024-09-29 22:57:13.981515+00	https://avatars.githubusercontent.com/u/1209171?v=4
144	labormedia	2024-09-25 20:45:43.30716+00	2024-09-29 22:57:15.347667+00	https://avatars.githubusercontent.com/u/120030?v=4
145	laurenelee	2024-09-25 20:45:43.331466+00	2024-09-29 22:57:16.107453+00	https://avatars.githubusercontent.com/u/24926734?v=4
147	leapalazzolo	2024-09-25 20:45:43.377267+00	2024-09-29 22:57:17.435879+00	https://avatars.githubusercontent.com/u/22482966?v=4
149	lisa-parity	2024-09-25 20:45:43.427238+00	2024-09-29 22:57:18.731699+00	https://avatars.githubusercontent.com/u/92225469?v=4
151	lovisabjorna	2024-09-25 20:45:43.477687+00	2024-09-29 22:57:20.519817+00	https://avatars.githubusercontent.com/u/164600138?v=4
153	magecnion	2024-09-25 20:45:43.527692+00	2024-09-29 22:57:21.857002+00	https://avatars.githubusercontent.com/u/5495235?v=4
155	MarijoR	2024-09-25 20:45:43.581765+00	2024-09-29 22:57:23.429782+00	https://avatars.githubusercontent.com/u/22522248?v=4
157	martintyrrell	2024-09-25 20:45:43.6344+00	2024-09-29 22:57:24.752698+00	https://avatars.githubusercontent.com/u/111347794?v=4
159	MathisWellmann	2024-09-25 20:45:43.684337+00	2024-09-29 22:57:26.72456+00	https://avatars.githubusercontent.com/u/26856233?v=4
160	mattdsilv	2024-09-25 20:45:43.709728+00	2024-09-29 22:57:27.518946+00	https://avatars.githubusercontent.com/u/109971179?v=4
162	Matthiewm23	2024-09-25 20:45:43.781589+00	2024-09-29 22:57:28.679886+00	https://avatars.githubusercontent.com/u/106464801?v=4
164	metricaez	2024-09-25 20:45:43.830917+00	2024-09-29 22:57:30.137982+00	https://avatars.githubusercontent.com/u/84690100?v=4
165	mgnsharon	2024-09-25 20:45:43.854629+00	2024-09-29 22:57:30.755348+00	https://avatars.githubusercontent.com/u/615329?v=4
167	michalkucharczyk	2024-09-25 20:45:43.912954+00	2024-09-29 22:57:32.131681+00	https://avatars.githubusercontent.com/u/1728078?v=4
169	MRamanenkau	2024-09-25 20:45:43.963594+00	2024-09-29 22:57:33.595011+00	https://avatars.githubusercontent.com/u/21261739?v=4
171	nanometerzhu	2024-09-25 20:45:44.02203+00	2024-09-29 22:57:35.062897+00	https://avatars.githubusercontent.com/u/5852979?v=4
172	naterarmstrong	2024-09-25 20:45:44.049057+00	2024-09-29 22:57:36.027396+00	https://avatars.githubusercontent.com/u/26288229?v=4
174	NicolasBiondini	2024-09-25 20:45:44.100586+00	2024-09-29 22:57:38.280116+00	https://avatars.githubusercontent.com/u/67608482?v=4
176	niklasp	2024-09-25 20:45:44.172037+00	2024-09-29 22:57:40.484602+00	https://avatars.githubusercontent.com/u/1685139?v=4
178	notlesh	2024-09-25 20:45:44.246516+00	2024-09-29 22:57:42.335503+00	https://avatars.githubusercontent.com/u/2967426?v=4
180	obrienalaribe	2024-09-25 20:45:44.309948+00	2024-09-29 22:57:43.699027+00	https://avatars.githubusercontent.com/u/11940652?v=4
181	ordian	2024-09-25 20:45:44.336058+00	2024-09-29 22:57:44.484676+00	https://avatars.githubusercontent.com/u/4211399?v=4
183	pablolteixeira	2024-09-25 20:45:44.396497+00	2024-09-29 22:57:45.900763+00	https://avatars.githubusercontent.com/u/96208410?v=4
185	patchworkkientz	2024-09-25 20:45:44.451421+00	2024-09-29 22:57:47.749374+00	https://avatars.githubusercontent.com/u/13970910?v=4
187	paulinecohenvorms	2024-09-25 20:45:44.508888+00	2024-09-29 22:57:49.02871+00	https://avatars.githubusercontent.com/u/100200917?v=4
189	pba-shared	2024-09-25 20:45:44.571204+00	2024-09-29 22:57:50.370092+00	https://avatars.githubusercontent.com/u/108496140?v=4
190	peetzweg	2024-09-25 20:45:44.612571+00	2024-09-29 22:57:51.559518+00	https://avatars.githubusercontent.com/u/839848?v=4
192	pepyakin	2024-09-25 20:45:44.663683+00	2024-09-29 22:57:52.871012+00	https://avatars.githubusercontent.com/u/2205845?v=4
194	pgherveou	2024-09-25 20:45:44.718277+00	2024-09-29 22:57:54.172615+00	https://avatars.githubusercontent.com/u/521091?v=4
195	pgrignaffini	2024-09-25 20:45:44.743402+00	2024-09-29 22:57:54.745338+00	https://avatars.githubusercontent.com/u/35811925?v=4
197	PieWol	2024-09-25 20:45:44.798871+00	2024-09-29 22:57:56.320959+00	https://avatars.githubusercontent.com/u/75956460?v=4
199	PoisonPhang	2024-09-25 20:45:44.854458+00	2024-09-29 22:57:58.085683+00	https://avatars.githubusercontent.com/u/17688291?v=4
201	PrNebula	2024-09-25 20:45:44.92038+00	2024-09-29 22:57:59.389525+00	https://avatars.githubusercontent.com/u/150043722?v=4
202	prybalko	2024-09-25 20:45:44.943764+00	2024-09-29 22:58:00.452093+00	https://avatars.githubusercontent.com/u/7165377?v=4
204	Randomacy	2024-09-25 20:45:44.992487+00	2024-09-29 22:58:01.769034+00	https://avatars.githubusercontent.com/u/4375872?v=4
206	RocioCM	2024-09-25 20:45:45.088534+00	2024-09-29 22:58:03.747049+00	https://avatars.githubusercontent.com/u/69587750?v=4
207	rogerjbos	2024-09-25 20:45:45.113351+00	2024-09-29 22:58:04.415387+00	https://avatars.githubusercontent.com/u/4925977?v=4
209	RostislavLitovkin	2024-09-25 20:45:45.194821+00	2024-09-29 22:58:06.018125+00	https://avatars.githubusercontent.com/u/77352013?v=4
211	rtomas	2024-09-25 20:45:45.274601+00	2024-09-29 22:58:08.046968+00	https://avatars.githubusercontent.com/u/944960?v=4
213	sacha-l	2024-09-25 20:45:45.336825+00	2024-09-29 22:58:09.47001+00	https://avatars.githubusercontent.com/u/23283108?v=4
214	sachindkagrawal15	2024-09-25 20:45:45.364455+00	2024-09-29 22:58:10.272238+00	https://avatars.githubusercontent.com/u/91769233?v=4
216	sandraleelt	2024-09-25 20:45:45.432491+00	2024-09-29 22:58:11.818559+00	https://avatars.githubusercontent.com/u/72225765?v=4
218	SBalaguer	2024-09-25 20:45:45.50908+00	2024-09-29 22:58:13.370434+00	https://avatars.githubusercontent.com/u/10047147?v=4
220	sebsadface	2024-09-25 20:45:45.593248+00	2024-09-29 22:58:14.956402+00	https://avatars.githubusercontent.com/u/69412453?v=4
221	serban300	2024-09-25 20:45:45.61898+00	2024-09-29 22:58:15.643194+00	https://avatars.githubusercontent.com/u/18124062?v=4
223	shawntabrizi	2024-09-25 20:45:45.667747+00	2024-09-29 22:58:17.194085+00	https://avatars.githubusercontent.com/u/1860335?v=4
225	SIakovlev	2024-09-25 20:45:45.717848+00	2024-09-29 22:58:19.107845+00	https://avatars.githubusercontent.com/u/23159640?v=4
227	SkymanOne	2024-09-25 20:45:45.768107+00	2024-09-29 22:58:20.466942+00	https://avatars.githubusercontent.com/u/17993104?v=4
228	SleepyEntropy	2024-09-25 20:45:45.793894+00	2024-09-29 22:58:21.067701+00	https://avatars.githubusercontent.com/u/5732922?v=4
230	smnunezleal	2024-09-25 20:45:45.847966+00	2024-09-29 22:58:22.840957+00	https://avatars.githubusercontent.com/u/19377360?v=4
232	Sophia-Gold	2024-09-25 20:45:45.903584+00	2024-09-29 22:58:25.130097+00	https://avatars.githubusercontent.com/u/19278114?v=4
233	stevestover-dot	2024-09-25 20:45:45.926754+00	2024-09-29 22:58:25.938967+00	https://avatars.githubusercontent.com/u/117296160?v=4
235	subtly	2024-09-25 20:45:45.972005+00	2024-09-29 22:58:27.455383+00	https://avatars.githubusercontent.com/u/6557250?v=4
237	Synaptic0n	2024-09-25 20:45:46.019274+00	2024-09-29 22:58:28.779388+00	https://avatars.githubusercontent.com/u/4516343?v=4
239	tcxcx	2024-09-25 20:45:46.068187+00	2024-09-29 22:58:30.533741+00	https://avatars.githubusercontent.com/u/72812526?v=4
240	Teamo0	2024-09-25 20:45:46.09301+00	2024-09-29 22:58:31.319153+00	https://avatars.githubusercontent.com/u/77360332?v=4
242	test-student-pba	2024-09-25 20:45:46.149356+00	2024-09-29 22:58:32.817065+00	https://avatars.githubusercontent.com/u/153927564?v=4
244	tobbelobb	2024-09-25 20:45:46.198325+00	2024-09-29 22:58:34.76308+00	https://avatars.githubusercontent.com/u/5753253?v=4
246	tommyrharper	2024-09-25 20:45:46.252182+00	2024-09-29 22:58:36.62694+00	https://avatars.githubusercontent.com/u/60899256?v=4
248	tonyalaribe	2024-09-25 20:45:46.302291+00	2024-09-29 22:58:38.228881+00	https://avatars.githubusercontent.com/u/6564482?v=4
249	TThanachaipornsakun	2024-09-25 20:45:46.327735+00	2024-09-29 22:58:38.805504+00	https://avatars.githubusercontent.com/u/101091988?v=4
251	u-hubar	2024-09-25 20:45:46.392106+00	2024-09-29 22:58:40.108624+00	https://avatars.githubusercontent.com/u/71610423?v=4
253	uosvald	2024-09-25 20:45:46.447244+00	2024-09-29 22:58:41.430815+00	https://avatars.githubusercontent.com/u/17180384?v=4
254	Valentinaga1	2024-09-25 20:45:46.470341+00	2024-09-29 22:58:42.378262+00	https://avatars.githubusercontent.com/u/63618254?v=4
256	vestival	2024-09-25 20:45:46.522326+00	2024-09-29 22:58:43.722332+00	https://avatars.githubusercontent.com/u/6848398?v=4
258	viktaur	2024-09-25 20:45:46.569195+00	2024-09-29 22:58:45.129797+00	https://avatars.githubusercontent.com/u/30535579?v=4
260	virgiliolino	2024-09-25 20:45:46.617408+00	2024-09-29 22:58:46.496677+00	https://avatars.githubusercontent.com/u/724429?v=4
262	vstam1	2024-09-25 20:45:46.688126+00	2024-09-29 22:58:48.042284+00	https://avatars.githubusercontent.com/u/10252263?v=4
263	wabkebab	2024-09-25 20:45:46.71819+00	2024-09-29 22:58:49.123461+00	https://avatars.githubusercontent.com/u/377844?v=4
265	weezy20	2024-09-25 20:45:46.766895+00	2024-09-29 22:58:51.377405+00	https://avatars.githubusercontent.com/u/15669111?v=4
267	wirednkod	2024-09-25 20:45:46.814916+00	2024-09-29 22:58:53.139031+00	https://avatars.githubusercontent.com/u/5408605?v=4
268	XingyeLu	2024-09-25 20:45:46.837903+00	2024-09-29 22:58:53.690773+00	https://avatars.githubusercontent.com/u/6131996?v=4
270	ZCalz	2024-09-25 20:45:46.888298+00	2024-09-29 22:58:55.181191+00	https://avatars.githubusercontent.com/u/40451059?v=4
\.


--
-- Name: issues_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kudosadmin
--

SELECT pg_catalog.setval('public.issues_id_seq', 1661, true);


--
-- Name: languages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kudosadmin
--

SELECT pg_catalog.setval('public.languages_id_seq', 1, false);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kudosadmin
--

SELECT pg_catalog.setval('public.projects_id_seq', 7, true);


--
-- Name: repositories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kudosadmin
--

SELECT pg_catalog.setval('public.repositories_id_seq', 15, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kudosadmin
--

SELECT pg_catalog.setval('public.users_id_seq', 271, true);


--
-- Name: __diesel_schema_migrations __diesel_schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.__diesel_schema_migrations
    ADD CONSTRAINT __diesel_schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: issues issues_pkey; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_pkey PRIMARY KEY (id);


--
-- Name: issues issues_repo_number_unique; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_repo_number_unique UNIQUE (repository_id, number);


--
-- Name: languages languages_pkey; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_pkey PRIMARY KEY (id);


--
-- Name: languages languages_slug_key; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.languages
    ADD CONSTRAINT languages_slug_key UNIQUE (slug);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_slug_key; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_slug_key UNIQUE (slug);


--
-- Name: repositories repositories_pkey; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_pkey PRIMARY KEY (id);


--
-- Name: repositories repositories_slug_key; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_slug_key UNIQUE (slug);


--
-- Name: repositories repositories_url_key; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_url_key UNIQUE (url);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: issues issues_assignee_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_assignee_id_fkey FOREIGN KEY (assignee_id) REFERENCES public.users(id);


--
-- Name: issues issues_repository_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.issues
    ADD CONSTRAINT issues_repository_id_fkey FOREIGN KEY (repository_id) REFERENCES public.repositories(id) ON DELETE CASCADE;


--
-- Name: repositories repositories_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kudosadmin
--

ALTER TABLE ONLY public.repositories
    ADD CONSTRAINT repositories_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: FUNCTION diesel_manage_updated_at(_tbl regclass); Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON FUNCTION public.diesel_manage_updated_at(_tbl regclass) TO kudos;


--
-- Name: FUNCTION diesel_set_updated_at(); Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON FUNCTION public.diesel_set_updated_at() TO kudos;


--
-- Name: TABLE __diesel_schema_migrations; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON TABLE public.__diesel_schema_migrations TO kudos;


--
-- Name: TABLE issues; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON TABLE public.issues TO kudos;


--
-- Name: SEQUENCE issues_id_seq; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON SEQUENCE public.issues_id_seq TO kudos;


--
-- Name: TABLE languages; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON TABLE public.languages TO kudos;


--
-- Name: SEQUENCE languages_id_seq; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON SEQUENCE public.languages_id_seq TO kudos;


--
-- Name: TABLE projects; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON TABLE public.projects TO kudos;


--
-- Name: SEQUENCE projects_id_seq; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON SEQUENCE public.projects_id_seq TO kudos;


--
-- Name: TABLE repositories; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON TABLE public.repositories TO kudos;


--
-- Name: SEQUENCE repositories_id_seq; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON SEQUENCE public.repositories_id_seq TO kudos;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON TABLE public.users TO kudos;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: kudosadmin
--

GRANT ALL ON SEQUENCE public.users_id_seq TO kudos;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: kudosadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE kudosadmin IN SCHEMA public GRANT ALL ON SEQUENCES TO kudos;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: kudosadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE kudosadmin IN SCHEMA public GRANT ALL ON FUNCTIONS TO kudos;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: kudosadmin
--

ALTER DEFAULT PRIVILEGES FOR ROLE kudosadmin IN SCHEMA public GRANT ALL ON TABLES TO kudos;


--
-- PostgreSQL database dump complete
--

