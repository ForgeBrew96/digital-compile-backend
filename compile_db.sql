--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg24.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg24.04+1)

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cards; Type: TABLE; Schema: public; Owner: forge_brew96
--

CREATE TABLE public.cards (
    card_id integer NOT NULL,
    name character varying(50) NOT NULL,
    point_value integer NOT NULL,
    creator_id integer,
    protocol_id integer,
    effects jsonb DEFAULT '{"top": " ", "lower": " ", "middle": " "}'::jsonb,
    is_original boolean DEFAULT true,
    CONSTRAINT cards_point_value_check CHECK (((point_value >= 0) AND (point_value <= 7)))
);


ALTER TABLE public.cards OWNER TO forge_brew96;

--
-- Name: cards_card_id_seq; Type: SEQUENCE; Schema: public; Owner: forge_brew96
--

CREATE SEQUENCE public.cards_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cards_card_id_seq OWNER TO forge_brew96;

--
-- Name: cards_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: forge_brew96
--

ALTER SEQUENCE public.cards_card_id_seq OWNED BY public.cards.card_id;


--
-- Name: protocols; Type: TABLE; Schema: public; Owner: forge_brew96
--

CREATE TABLE public.protocols (
    protocol_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(100) NOT NULL,
    img_url character varying(255) NOT NULL,
    playstyle character varying(255) NOT NULL
);


ALTER TABLE public.protocols OWNER TO forge_brew96;

--
-- Name: protocols_protocol_id_seq; Type: SEQUENCE; Schema: public; Owner: forge_brew96
--

CREATE SEQUENCE public.protocols_protocol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.protocols_protocol_id_seq OWNER TO forge_brew96;

--
-- Name: protocols_protocol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: forge_brew96
--

ALTER SEQUENCE public.protocols_protocol_id_seq OWNED BY public.protocols.protocol_id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: forge_brew96
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(250) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.users OWNER TO forge_brew96;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: forge_brew96
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO forge_brew96;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: forge_brew96
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: cards card_id; Type: DEFAULT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.cards ALTER COLUMN card_id SET DEFAULT nextval('public.cards_card_id_seq'::regclass);


--
-- Name: protocols protocol_id; Type: DEFAULT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.protocols ALTER COLUMN protocol_id SET DEFAULT nextval('public.protocols_protocol_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: cards; Type: TABLE DATA; Schema: public; Owner: forge_brew96
--

COPY public.cards (card_id, name, point_value, creator_id, protocol_id, effects, is_original) FROM stdin;
1	love-1	1	1	9	{"top": "", "lower": "end: you may give 1 card from your hand to your opponent. if you do, draw 2", "middle": "draw the top card of your opponents deck."}	t
2	love-2	2	1	9	{"top": "", "lower": "", "middle": "your opponent draws 1 card. refresh"}	t
3	love-3	3	1	9	{"top": "", "lower": "", "middle": "take 1 random card from your opponents hand. give 1 card from your hand to your opponent."}	t
4	love-4	4	1	9	{"top": "", "lower": "", "middle": "reveal 1 card from your hand. flip 1 card."}	t
5	love-5	5	1	9	{"top": "", "lower": "", "middle": "you discard 1 card."}	t
6	love-6	6	1	9	{"top": "", "lower": "", "middle": "your opponent draws 2 cards."}	t
7	apathy-1	0	1	1	{"top": "Your total value in this line is increased by 1 for each face-down card in this line.", "lower": "", "middle": ""}	t
8	apathy-2	1	1	1	{"top": "", "lower": "", "middle": "Flip all other face-up cards in this line."}	t
9	apathy-3	2	1	1	{"top": "Ignore all middle commands on cards in this line.", "lower": "When this card would be covered: first, flip this card.", "middle": ""}	t
10	apathy-4	3	1	1	{"top": "", "lower": "", "middle": "Flip 1 of your opponent's face-up cards."}	t
11	apathy-5	4	1	1	{"top": "", "lower": "", "middle": "You may flip 1 of your face-up covered cards."}	t
12	apathy-6	5	1	1	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
13	darkness-1	0	1	10	{"top": "", "lower": "Skip your Check Cache phase.", "middle": "Draw 3 cards. Shift 1 of your opponent's covered cards."}	t
14	darkness-2	1	1	10	{"top": "", "lower": "", "middle": "Flip 1 of your opponent's cards. You may shift that card."}	t
15	darkness-3	2	1	10	{"top": "All face-down cards in this stack have a value of 4.", "lower": "", "middle": "You may flip 1 covered card in this line."}	t
16	darkness-4	3	1	10	{"top": "", "lower": "", "middle": "Play 1 card face-down in another line."}	t
17	darkness-5	4	1	10	{"top": "", "lower": "", "middle": "Shift 1 face-down card."}	t
18	darkness-6	5	1	10	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
19	death-1	0	1	13	{"top": "", "lower": "", "middle": "Delete 1 card from each other line."}	t
20	death-2	1	1	13	{"top": "Start: You may draw 1 card. If you do, delete 1 other card, then delete this card.", "lower": "", "middle": ""}	t
21	death-3	2	1	13	{"top": "", "lower": "", "middle": "Delete all cards in 1 line with values of 1 or 2."}	t
22	death-4	3	1	13	{"top": "", "lower": "", "middle": "Delete 1 face-down card."}	t
23	death-5	4	1	13	{"top": "", "lower": "", "middle": "Delete a card with a value of 0 or 1."}	t
24	death-6	5	1	13	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
25	fire-1	0	1	11	{"top": "", "lower": "When this card would be covered: first, draw 1 card and flip 1 other card.", "middle": "Flip 1 other card. Draw 2 cards."}	t
26	fire-2	1	1	11	{"top": "", "lower": "", "middle": "Discard 1 card. If you do, delete 1 card."}	t
27	fire-3	2	1	11	{"top": "", "lower": "", "middle": "Discard 1 card. If you do, return 1 card."}	t
28	fire-4	3	1	11	{"top": "", "lower": "End: You may discard 1 card. If you do, flip 1 card.", "middle": ""}	t
29	fire-5	4	1	11	{"top": "", "lower": "", "middle": "Discard 1 or more cards. Draw the amount discarded plus 1."}	t
30	fire-6	5	1	11	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
31	gravity-1	0	1	12	{"top": "", "lower": "", "middle": "For every 2 cards in this line, play the top card of your deck face-down under this card."}	t
32	gravity-2	1	1	12	{"top": "", "lower": "", "middle": "Draw 2 cards. Shift 1 card either to or from this line."}	t
33	gravity-3	2	1	12	{"top": "", "lower": "", "middle": "Flip 1 card. Shift that card to this line."}	t
34	gravity-4	4	1	12	{"top": "", "lower": "", "middle": "Shift 1 face-down card to this line."}	t
35	gravity-5	5	1	12	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
36	gravity-6	6	1	12	{"top": "", "lower": "", "middle": "Your opponent plays the top card of their deck face-down in this line."}	t
37	hate-1	0	1	8	{"top": "", "lower": "", "middle": "Delete 1 card."}	t
38	hate-2	1	1	8	{"top": "", "lower": "", "middle": "Discard 3 cards. Delete 1 card."}	t
39	hate-3	2	1	8	{"top": "", "lower": "", "middle": "Delete your highest value card. Delete your opponent's highest value card."}	t
40	hate-4	3	1	8	{"top": "After you delete cards: Draw 1 card.", "lower": "", "middle": ""}	t
41	hate-5	4	1	8	{"top": "", "lower": "When this card would be covered: first, delete the lowest value covered card in this line.", "middle": ""}	t
42	hate-6	5	1	8	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
43	life-1	0	1	2	{"top": "", "lower": "", "middle": "Play the top card of your deck face-down in each line where you have a card."}	t
44	life-2	1	1	2	{"top": "", "lower": "", "middle": "Flip 1 card. Flip 1 card."}	t
45	life-3	2	1	2	{"top": "", "lower": "", "middle": "Draw 1 card. You may flip 1 face-down card."}	t
46	life-4	3	1	2	{"top": "", "lower": "When this card would be covered: first, play the top card of your deck face-down in another line.", "middle": ""}	t
47	life-5	4	1	2	{"top": "", "lower": "", "middle": "If this card is covering a card, draw 1 card."}	t
48	life-6	5	1	2	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
49	light-1	0	1	6	{"top": "", "lower": "", "middle": "Flip 1 card. Draw cards equal to that card's value."}	t
50	light-2	1	1	6	{"top": "", "lower": "End: Draw 1 card.", "middle": ""}	t
51	light-3	2	1	6	{"top": "", "lower": "", "middle": "Draw 2 cards. Reveal 1 face-down card. You may shift or flip that card."}	t
52	light-4	3	1	6	{"top": "", "lower": "", "middle": "Shift all face-down cards in this line to another line."}	t
53	light-5	4	1	6	{"top": "", "lower": "", "middle": "Your opponent reveals their hand."}	t
54	light-6	5	1	6	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
55	metal-1	0	1	5	{"top": "Your opponent's total value in this line is reduced by 2.", "lower": "", "middle": "Flip 1 card."}	t
56	metal-2	1	1	5	{"top": "", "lower": "", "middle": "Draw 2 cards. Your opponent cannot compile next turn."}	t
57	metal-3	2	1	5	{"top": "Your opponent cannot play cards face-down in this line.", "lower": "", "middle": ""}	t
58	metal-4	3	1	5	{"top": "", "lower": "", "middle": "Draw 1 card. Delete all cards in 1 other line with 8 or more cards."}	t
59	metal-5	5	1	5	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
60	metal-6	6	1	5	{"top": "When this card would be covered or flipped: first, delete this card.", "lower": "", "middle": ""}	t
61	plague-1	0	1	4	{"top": "", "lower": "Your opponent cannot play cards in this line.", "middle": "Your opponent discards 1 card."}	t
62	plague-2	1	1	4	{"top": "After your opponent discards cards: Draw 1 card.", "lower": "", "middle": "Your opponent discards 1 card."}	t
63	plague-3	2	1	4	{"top": "", "lower": "", "middle": "Discard 1 or more cards. Your opponent discards the amount of cards discarded plus 1."}	t
64	plague-4	3	1	4	{"top": "", "lower": "", "middle": "Flip each other face-up card."}	t
65	plague-5	4	1	4	{"top": "", "lower": "End: Your opponent deletes 1 of their face-down cards. You may flip this card.", "middle": ""}	t
66	plague-6	5	1	4	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
67	psychic-1	0	1	3	{"top": "", "lower": "", "middle": "Draw 2 cards. Your opponent discards 2 cards, then reveals their hand."}	t
68	psychic-2	1	1	3	{"top": "Your opponent can only play cards face-down.", "lower": "Start: Flip this card.", "middle": ""}	t
69	psychic-3	2	1	3	{"top": "", "lower": "", "middle": "Your opponent discards 2 cards. Rearrange their protocols."}	t
70	psychic-4	3	1	3	{"top": "", "lower": "", "middle": "Your opponent discards 1 card. Shift 1 of their cards."}	t
71	psychic-5	4	1	3	{"top": "", "lower": "End: You may return 1 of your opponent's cards. If you do, flip this card.", "middle": ""}	t
72	psychic-6	5	1	3	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
73	speed-1	0	1	14	{"top": "", "lower": "", "middle": "Play 1 card."}	t
74	speed-2	1	1	14	{"top": "After you Clear Cache: Draw 1 card.", "lower": "", "middle": "Draw 2 cards."}	t
75	speed-3	2	1	14	{"top": "When this card would be deleted by Compiling: Shift this card, even if this card is covered.", "lower": "", "middle": ""}	t
76	speed-4	3	1	14	{"top": "", "lower": "End: You may shift 1 of your cards. If you do, flip this card.", "middle": "Shift 1 of your other cards."}	t
77	speed-5	4	1	14	{"top": "", "lower": "", "middle": "Shift 1 of your opponent's face-down cards."}	t
78	speed-6	5	1	14	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
79	spirit-1	0	1	15	{"top": "", "lower": "Skip your Check Cache phase.", "middle": "Refresh. Draw 1 card."}	t
80	spirit-2	1	1	15	{"top": "You can play cards in any line.", "lower": "Start: Either discard 1 card or flip this card.", "middle": "Draw 2 cards."}	t
81	spirit-3	2	1	15	{"top": "", "lower": "", "middle": "You may flip 1 card."}	t
82	spirit-4	3	1	15	{"top": "After you draw cards: You may shift this card, even if this card is covered.", "lower": "", "middle": ""}	t
83	spirit-5	4	1	15	{"top": "", "lower": "", "middle": "Swap the positions of 2 of your protocols."}	t
84	spirit-6	5	1	15	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
85	water-1	0	1	7	{"top": "", "lower": "", "middle": "Flip 1 other card. Flip this card."}	t
86	water-2	1	1	7	{"top": "", "lower": "", "middle": "Play the top card of your deck face-down in each other line."}	t
87	water-3	2	1	7	{"top": "", "lower": "", "middle": "Draw 2 cards. Rearrange your protocols."}	t
88	water-4	3	1	7	{"top": "", "lower": "", "middle": "Return all cards with a value of 2 in 1 line."}	t
89	water-5	4	1	7	{"top": "", "lower": "", "middle": "Return 1 of your cards."}	t
90	water-6	5	1	7	{"top": "", "lower": "", "middle": "You discard 1 card."}	t
94	But, but, but Shanks...	3	2	12	{"top": "", "lower": "Summon a 4 cost character from your graveyard", "middle": "Add Two Don! to your leader"}	f
93	TESTTWOUPDATE	5	2	9	{"top": "TEST", "lower": "TEST", "middle": "TESTCARD"}	f
96	dog	2	2	4	{"top": "1", "lower": "7", "middle": "5"}	f
97	piggy	3	2	4	{"top": "h", "lower": "", "middle": "h"}	f
98	g4rg	6	2	10	{"top": "gd", "lower": "", "middle": "s"}	f
99	ghg	4	2	9	{"top": "sd", "lower": "s", "middle": "s"}	f
95	Cat, but not cat	1	2	1	{"top": "1", "lower": "1", "middle": "1"}	f
\.


--
-- Data for Name: protocols; Type: TABLE DATA; Schema: public; Owner: forge_brew96
--

COPY public.protocols (protocol_id, name, description, img_url, playstyle) FROM stdin;
1	Apathy	lack of interest, enthusiasm, or concern.	./protocol_images/Screenshots/apathy.png	Flip Face-Down
2	Life	the existence of an individual human being or animal.	./protocol_images/Screenshots/life.jpg.png	Flip, Top Deck Play, Draw
3	Psychic	relating to or denoting faculties or phenomena that are apparently inexplicable by natural laws.	./protocol_images/Screenshots/psychic.png	Draw, Manipulate, Shift
4	Plague	cause continual trouble or distress to.	./protocol_images/Screenshots/plague.png	Forced Discard, Flip
5	Metal	a solid material that is typically hard, shiny, malleable, fusible, and ductile.	./protocol_images/Screenshots/metal.png	Prevent, Draw, Flip
6	Light	the natural agent that stimulates sight and makes things visible.	./protocol_images/Screenshots/light.png	Draw, Flip, Shift
8	Hate	feel intense or passionate dislike for	./protocol_images/Screenshots/hate.png	Delete Theirs and Yours
9	Love	an intense feeling of deep affection.	./protocol_images/Screenshots/love.png	Draw, Gift, Exchange
10	Darkness	the partial or total absence of light.	./protocol_images/Screenshots/darkness.png	Draw, Shift, Manipulate
11	Fire	combustion or burning, in which substances combine chemically	./protocol_images/Screenshots/fire.png	Discard for Effect
12	Gravity	the force that attracts a body toward the center of the earth, or a physical body having mass.	./protocol_images/Screenshots/gravity.jpg.png	Shift, Flip, Draw
13	Death	the end of the life of a person or organism.	./protocol_images/Screenshots/death.jpg.png	Delete, Draw
14	Speed	the rate at which something operates.	./protocol_images/Screenshots/speed.jpg	Draw, Play, Shift
15	Spirit	the nonphysical part of a person which is the seat of emotions and character	./protocol_images/Screenshots/spirit.png	Flip, Shift, Draw
7	Water	colorless, transparent, odorless liquid - is the basis of the fluids of living organisms.	./protocol_images/Screenshots/water.jpg	Return, Draw, Flip
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: forge_brew96
--

COPY public.users (id, username, password, created_at, updated_at) FROM stdin;
1	adminUser	adminUser	2024-12-10 16:28:59.523469	2024-12-10 16:28:59.523469
2	UserNumber2	$2b$12$nEn427A3hNTL3uHdl/em5uqI.s4rUHo8NeyLTQ/wuaYQWF5fCFMQ6	2024-12-11 14:45:49.714074	2024-12-11 14:45:49.714074
3	TestAccountFrontEnd	$2b$12$.9RJPHYFlSBPnfGq9sLeeuA1jqU67m0nd0s68n8.Cl.0i4K3xw/G6	2024-12-15 16:54:34.065697	2024-12-15 16:54:34.065697
\.


--
-- Name: cards_card_id_seq; Type: SEQUENCE SET; Schema: public; Owner: forge_brew96
--

SELECT pg_catalog.setval('public.cards_card_id_seq', 99, true);


--
-- Name: protocols_protocol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: forge_brew96
--

SELECT pg_catalog.setval('public.protocols_protocol_id_seq', 17, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: forge_brew96
--

SELECT pg_catalog.setval('public.users_id_seq', 3, true);


--
-- Name: cards cards_pkey; Type: CONSTRAINT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (card_id);


--
-- Name: protocols protocols_pkey; Type: CONSTRAINT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.protocols
    ADD CONSTRAINT protocols_pkey PRIMARY KEY (protocol_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cards cards_creator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);


--
-- Name: cards cards_protocol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: forge_brew96
--

ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.protocols(protocol_id);


--
-- PostgreSQL database dump complete
--

