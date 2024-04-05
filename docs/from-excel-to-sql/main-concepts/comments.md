# Comments 📝

> [!SUCCESS]
>
> Comments are a way to add notes to your SQL code. They are not executed and are only there for the benefit of the reader.

> [!NOTE]
>
> Comments can go anywhere in your SQL code! 🚀

## Comments can be written with `--` or `/* */`

A "comment" in an SQL statement is some text which is ignored when the query is run. It's a way to add notes to your code to help explain what's happening.

There are two ways to write comments in SQL:

1. [Single-line comments](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/comment-transact-sql) using `--` which comment out the rest of the line
2. [Multi-line comments](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql) using `/* */` which comment out everything they enclose

For info, the multi-line comment goes by several different names:

- "C-style" comment
- "Block" comment
- "Slash-star" comment

Writing comments is super easy, for example:

```sql
-- This is a title
SELECT *
FROM HumanResources.Department
;

/*
This query won't run

SELECT *
FROM HumanResources.Department
;
*/
```

> [!WARNING]
>
> Comments can be helpful for explaining bits of code, but a comment should never excuse bad code! Use them sparingly and only when necessary.

> [!TIP]
>
> This is my personal preference, but I'd recommend using the slash-star comments for any "documentation", and the double-dash comments for any (temporary) commented-out code. This is because the double-dash comments are the ones used by most IDEs to "comment out" code, so following this practice makes it easier to distinguish between the two types of comments.

## Further reading

Check out the [official Microsoft documentation](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/language-elements-transact-sql) for more information on comments at:

- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/comment-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/comment-transact-sql)
- [https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql](https://learn.microsoft.com/en-us/sql/t-sql/language-elements/slash-star-comment-transact-sql)

The video version of this content is also available at:

- https://youtu.be/H6SfeXFWWmg
