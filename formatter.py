import sqlite3


db_connect = sqlite3.connect("nce_articles.sqlite3")
db_cursor = db_connect.cursor()


def create_tables():

    articles_table = '''CREATE TABLE IF NOT EXISTS articles
                     (id INTEGER PRIMARY KEY AUTOINCREMENT,
                     title TEXT,
                     chinese_title TEXT,
                     article TEXT,
                     translate TEXT)'''

    words_table = '''CREATE TABLE IF NOT EXISTS words
                     (id INTEGER PRIMARY KEY AUTOINCREMENT,
                     word TEXT,
                     level INTEGER)'''

    db_cursor.execute(articles_table)
    db_cursor.execute(words_table)


def cut_off_content(file, end_flag):
    line = file.readline()
    content = ""

    while not line.startswith(end_flag):
        content += line
        line = file.readline()

    return content


def extract_articles():
    articles_file = open("nce4_articles.txt")

    insert_article = "INSERT INTO articles(title, chinese_title, article, translate) VALUES(?, ?, ?, ?)"

    line = articles_file.readline()

    while line:

        if line.startswith("##title"):
            title = articles_file.readline()
            print("hello", title)
        elif line.startswith("##chinese_title"):
            chinese_title = articles_file.readline()
        elif line.startswith("##article_begin"):
            article = cut_off_content(articles_file, "##article_end")
        elif line.startswith("##translate_begin"):
            translate = cut_off_content(articles_file, "##translate_end")
            db_cursor.execute(insert_article, (title, chinese_title, article, translate))

        line = articles_file.readline()

    db_connect.commit()


def extract_words():
    words_file = open("nce4_words.txt")

    insert_word = "INSERT INTO words(word, level) VALUES(?, ?)"

    words_file.readline()
    line = words_file.readline()

    while line:
        newline = line.replace("\n", "")
        word_level = newline.split("\t")

        word = word_level[0]
        level = word_level[1]

        db_cursor.execute(insert_word, (word, level))

        print(word, level)

        line = words_file.readline()

    db_connect.commit()

# create_tables()

# extract_articles()

# extract_words()

# db_connect.close()
