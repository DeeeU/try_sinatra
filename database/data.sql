CREATE TABLE memoes (
  id uuid DEFAULT uuid_generate_v4(),
  title text NOT NULL,
  text text NOT NULL,
  time timestamp default CURRENT_TIMESTAMP
);
