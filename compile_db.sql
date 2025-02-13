PGDMP  5                      }         
   compile_db     16.6 (Ubuntu 16.6-1.pgdg24.04+1)     16.6 (Ubuntu 16.6-1.pgdg24.04+1)     `           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            a           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            b           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            c           1262    24815 
   compile_db    DATABASE     r   CREATE DATABASE compile_db WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'C.UTF-8';
    DROP DATABASE compile_db;
                forge_brew96    false            �            1259    24835    cards    TABLE     �  CREATE TABLE public.cards (
    card_id integer NOT NULL,
    name character varying(50) NOT NULL,
    point_value integer NOT NULL,
    creator_id integer,
    protocol_id integer,
    effects jsonb DEFAULT '{"top": " ", "lower": " ", "middle": " "}'::jsonb,
    is_original boolean DEFAULT true,
    CONSTRAINT cards_point_value_check CHECK (((point_value >= 0) AND (point_value <= 7)))
);
    DROP TABLE public.cards;
       public         heap    forge_brew96    false            �            1259    24834    cards_card_id_seq    SEQUENCE     �   CREATE SEQUENCE public.cards_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.cards_card_id_seq;
       public          forge_brew96    false    220            d           0    0    cards_card_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.cards_card_id_seq OWNED BY public.cards.card_id;
          public          forge_brew96    false    219            �            1259    24826 	   protocols    TABLE     �   CREATE TABLE public.protocols (
    protocol_id integer NOT NULL,
    name character varying(100) NOT NULL,
    description character varying(100) NOT NULL,
    img_url character varying(255) NOT NULL,
    playstyle character varying(255) NOT NULL
);
    DROP TABLE public.protocols;
       public         heap    forge_brew96    false            �            1259    24825    protocols_protocol_id_seq    SEQUENCE     �   CREATE SEQUENCE public.protocols_protocol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.protocols_protocol_id_seq;
       public          forge_brew96    false    218            e           0    0    protocols_protocol_id_seq    SEQUENCE OWNED BY     W   ALTER SEQUENCE public.protocols_protocol_id_seq OWNED BY public.protocols.protocol_id;
          public          forge_brew96    false    217            �            1259    24817    users    TABLE       CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(250) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);
    DROP TABLE public.users;
       public         heap    forge_brew96    false            �            1259    24816    users_id_seq    SEQUENCE     �   CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public          forge_brew96    false    216            f           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;
          public          forge_brew96    false    215            �           2604    24838    cards card_id    DEFAULT     n   ALTER TABLE ONLY public.cards ALTER COLUMN card_id SET DEFAULT nextval('public.cards_card_id_seq'::regclass);
 <   ALTER TABLE public.cards ALTER COLUMN card_id DROP DEFAULT;
       public          forge_brew96    false    219    220    220            �           2604    24829    protocols protocol_id    DEFAULT     ~   ALTER TABLE ONLY public.protocols ALTER COLUMN protocol_id SET DEFAULT nextval('public.protocols_protocol_id_seq'::regclass);
 D   ALTER TABLE public.protocols ALTER COLUMN protocol_id DROP DEFAULT;
       public          forge_brew96    false    217    218    218            �           2604    24820    users id    DEFAULT     d   ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public          forge_brew96    false    216    215    216            ]          0    24835    cards 
   TABLE DATA           j   COPY public.cards (card_id, name, point_value, creator_id, protocol_id, effects, is_original) FROM stdin;
    public          forge_brew96    false    220   p       [          0    24826 	   protocols 
   TABLE DATA           W   COPY public.protocols (protocol_id, name, description, img_url, playstyle) FROM stdin;
    public          forge_brew96    false    218   (       Y          0    24817    users 
   TABLE DATA           O   COPY public.users (id, username, password, created_at, updated_at) FROM stdin;
    public          forge_brew96    false    216   w+       g           0    0    cards_card_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.cards_card_id_seq', 100, true);
          public          forge_brew96    false    219            h           0    0    protocols_protocol_id_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.protocols_protocol_id_seq', 17, true);
          public          forge_brew96    false    217            i           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('public.users_id_seq', 5, true);
          public          forge_brew96    false    215            �           2606    24844    cards cards_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_pkey PRIMARY KEY (card_id);
 :   ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_pkey;
       public            forge_brew96    false    220            �           2606    24833    protocols protocols_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.protocols
    ADD CONSTRAINT protocols_pkey PRIMARY KEY (protocol_id);
 B   ALTER TABLE ONLY public.protocols DROP CONSTRAINT protocols_pkey;
       public            forge_brew96    false    218            �           2606    24824    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            forge_brew96    false    216            �           2606    24845    cards cards_creator_id_fkey    FK CONSTRAINT     }   ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_creator_id_fkey FOREIGN KEY (creator_id) REFERENCES public.users(id);
 E   ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_creator_id_fkey;
       public          forge_brew96    false    220    216    3266            �           2606    24850    cards cards_protocol_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.cards
    ADD CONSTRAINT cards_protocol_id_fkey FOREIGN KEY (protocol_id) REFERENCES public.protocols(protocol_id);
 F   ALTER TABLE ONLY public.cards DROP CONSTRAINT cards_protocol_id_fkey;
       public          forge_brew96    false    220    3268    218            ]   �  x��ZMo�6=+��ͥ��a}ZΥH�l�SI���p-�"K�$�5���%9C��%�����7>��:y��>����t��n���-���!�yy`������=��#�ddE����r+T$�EB�>��]Y����l-�K��T�@<��͒$gX~פ����rmB�$a��������V��Fl5	,iB���H���S	������}~��¹:�8�/3��4iP N`mP����Yfd�g;�t�C�S�I����:TP�]�1���s��m�#��\��E�&^mʆ����{F��k(�I��C�?�*Fk���Gn纬�����}J�C�_���*͉�9��挼�Y���9)��+�߃����X*��L��MQVLB:Y��-�ך�E/�n�ה�3��C�Ϲk�;�?�묪��H�w�/�seb O�7�gG����8�uE(�oG���ڤj�a���x"y�y�N��;	��
V�J����7n���>塍�si2�K�`;.��G��K���~7�-/8��2�v����Z�Ӥ����hQ��ׯyO��ʝ�R')�knC0v0;��{��t���4T��G����F��zN@8���ā��P�kzA�(j�tP�K'a\�J����Yc&1U�>�戎���_Z5���d�W��I�@��7�J(�3F��m�EcP���*�m+R��!kR�g-��m������5ѭ}[���b�f>�{a�v���d��G]�����I���PD�MG�<�(�TloE1�\��DFP���"��i����jUs�(PrST��W�I*m��Q���if0jÞC�6��q�mE����A��t[�E���.��J��8Q��eg�u6}Ϛ����r���(�JCFZ��s���/�i�N��H�&��%��Z�P�vV�n�I�2)~�Rp�e��$A�o9Q������m�t]����ƒ�?��-40��
�Z<�b��6F�>���)�>���������01���,a�#m�ه�\��$��6)��C���Z�������z�	w놫^F3@�˸�P�ŵ�J!p�����s�*T�3\����I�\>$��w�l��e'�/��/D��P!�$�T�����sw�����?b���+8@vC�ʰ�gF�@`h�n�Ok��{Ǭ��Fe�?��eq6Xr�Mڠ����ɘ���9$LE<x�s��9��ކ�d��O�.B����6���u4�i�E�9��X� *�3 �)���<oeC	A\v�f:��d�	P�!:@hP�5t����ٲ�樨�3'����Ȑ���
��X�8@a�����?�tڊ|/�|o���o^j���H:Z�B��v|��� -�1��&��=����InРƝ6ȗH5���P�9�A���}�Ց���w�AD�:|36{�����|��#5��*��6}�)+@�AOՇ1���1�W�����a�S0j]&O��]��й�=2hC0}����0:��:u}Rb5�b!�v�x�z��G�2���������U��PΖ�����n>ǉ�P�����?
IY���`h�瓟?��e�Z�FV,JZU��0\�*�rU��Jl޲�J/b5�yMeZ ^�-#�w�ј4���K���i�����{٘r�;���D͂쎂v�0���/����o)\�X����"D*���.������/�o������n���%`�E�f���U�'mL��-X;�U�Z�Q8���ݑ˵n��Yp>yY8],9ZVe�-r�*���g�q����ɞ+2�YD�xi�8��,a�h.K�b���\㱫�B��W{��i���Cu�}�3i�ɮB��C���ݺ^t'�]YgMV��k�Iq�XP����q�(��q1��X��fR�!6��{�(����duٱvx��{w F���3d�SoԽ��NW�H�DP�$�nЅ���c8��e������w��'Z�ճ�̑~��ے���\ռfKiEW␞~�$���ȩLS�J�P?����Y7��?����w^_^_���Ǘ���G�JO���xhآ�8Q�o�� /v6A��=�g��o���j��St���i#j��k��&�+Q���yjH]V���z�93�K.~�D���oe�J����-��ή���$w²      [   O  x�uT]��6|�~���Ѧ��K��P�˚ZI�Q�BR���w��/.P~�%rgvvvoՑ)*�ٷ:tZ��X�IOS�:D�z�6�{���擳���Df����]+u��L�~�=�:μ��H���N=N�mA��YS֗��A�0r��u >���I
Hy%%w��Ѳӏ��rsx��6�\ |�Ӱ$k��b�Oզ�ee��c�6��	
��"��q�� �V
k����Hn��Bt��N�H>�{
m}}ζկ�LN���9|+��=iV巴�h���9��f��`sP'LfQ�̓��9�8s��Ɲ�o8�*U^��d��1\|�F}�]���mʌ2Et�-�3F1�#^��6��v$��%�{�R��{����A|���zH��DUdGY*� �[������.[N�v�zdOP��L4Mu4nU~�@�N�X�'H	ގ.[�O��(�mM3��՛��3+Csb��D��,PB�E�E[H�F�#Dí>�d(��߫���)�B9kGXA�N�d�$�>�r+a� #F�X:��N(��l�u��f�B�!�8��p������*"�8UɤlǢP�I����X63K�l�Mo�ҍ�7[�|P���]��OE߉R�~K�@jg��cac�A�oL�ƚ�9���%�YsW�+��`<�4u	��p����%?>=#x|���:R|��C�P"L&�>rȢ�)]7�j���k��5�~��9Խ�0gOs΂sB���:���|J����Ů 'y����u+vu�H�?i���9��楴؉�ץ�Y���Sh�|��rʰ�5$�%���׸/W*�9b����%aV]��J���7M�/�Q��      Y   j  x�}�MS�@E�ɯ`��N�C������4M:&���[��h�"�Wu��=��i[d&it�뢘��w�ir�8e dr����b�k�t�Kh�P����x��h�{�යB�ɨf�<���>��⻾�^���!A"� ���̉us�m6�5U��04ۿ"Hގ磕��.�fU��jm{�J�_`�ōL��9�L���E�D��\!��oA.8��x�r���?k�Dϖ�^�s�R�k��F7�g�Ҥ|7�:m��>M���!���Et1�G�`̃�r��-�o��ޗ�ޯ�K�)z��ӹ=f�v;u��;z�lj�ˁHՠZM�ye���!��T� �������     