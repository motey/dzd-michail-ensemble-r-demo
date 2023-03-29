import pymysql.cursors

connection = pymysql.connect(
    host="localhost",
    user="root",
    password="ensemble",
    database="homo_sapiens_core_109_38",
    cursorclass=pymysql.cursors.DictCursor,
)
with connection:
    with connection.cursor() as cursor:
        # Read a single record
        sql = "SELECT * FROM biotype"
        cursor.execute(sql)
        result = cursor.fetchone()
        print(result)
