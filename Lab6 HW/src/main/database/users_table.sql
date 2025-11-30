create table users
(
    id         int auto_increment
        primary key,
    username   varchar(50)                                      not null,
    password   varchar(255)                                     not null,
    full_name  varchar(100)                                     not null,
    role       enum ('admin', 'user') default 'user'            null,
    is_active  tinyint(1)             default 1                 null,
    created_at timestamp              default CURRENT_TIMESTAMP null,
    last_login timestamp                                        null,
    constraint username
        unique (username)
);

# Change to hash passwords using passwordHashGenerator.java

insert into users (username, password, full_name, role, is_active) values
('admin', '$2a$10$7QJf1Z6F6k9b8H0y5Z8lUuX9zFhQeG5K1jKqFhZlYpE6Yx1JfD3G6', 'Administrator', 'admin', 1),
('john', '$2a$10$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36Zy4r7r7r7r7r7r7r7r7rO', 'John Doe', 'user', 1);

