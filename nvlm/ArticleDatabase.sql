CREATE DATABASE Aticle_Database
GO
USE Aticle_Database
GO

ALTER TABLE [dbo].[ARTICLE] ALTER COLUMN ArticleID nvarchar(255) NOT NULL;
ALTER TABLE [dbo].[ARTICLE] ADD CONSTRAINT PK_ARTICLES PRIMARY KEY (ArticleID);

ALTER TABLE [dbo].[IMAGE] ALTER COLUMN ImageID NVARCHAR(255) NOT NULL;
ALTER TABLE [dbo].[IMAGE] ADD CONSTRAINT PK_IMAGE PRIMARY KEY (ImageID);

ALTER TABLE [dbo].[VIDEO] ALTER COLUMN VideoID NVARCHAR(255) NOT NULL;
ALTER TABLE [dbo].[VIDEO] ADD CONSTRAINT PK_VIDEO PRIMARY KEY (VideoID);

ALTER TABLE [dbo].[ARTICLE_IMAGE] ALTER COLUMN ArticleID NVARCHAR(255) NOT NULL;
ALTER TABLE [dbo].[ARTICLE_IMAGE] ALTER COLUMN ImageID NVARCHAR(255) NOT NULL;

DELETE FROM [dbo].[ARTICLE_IMAGE]
WHERE ArticleID = 'dong-185250317170211344';
ALTER TABLE [dbo].[ARTICLE_IMAGE]
ADD CONSTRAINT FK_ARTICLE_IMAGE_ARTICLE FOREIGN KEY (ArticleID) REFERENCES [dbo].[ARTICLE](ArticleID);

ALTER TABLE [dbo].[ARTICLE_IMAGE]
ADD CONSTRAINT FK_ARTICLE_IMAGE_IMAGE FOREIGN KEY (ImageID) REFERENCES [dbo].[IMAGE](ImageID);


ALTER TABLE [dbo].[ARTICLE_VIDEO] ALTER COLUMN ArticleID NVARCHAR(255) NOT NULL;
ALTER TABLE [dbo].[ARTICLE_VIDEO] ALTER COLUMN VideoID NVARCHAR(255) NOT NULL;

ALTER TABLE [dbo].[ARTICLE_VIDEO]
ADD CONSTRAINT FK_ARTICLE_VIDEO_ARTICLE FOREIGN KEY (ArticleID) REFERENCES [dbo].[ARTICLE](ArticleID);

ALTER TABLE [dbo].[ARTICLE_VIDEO]
ADD CONSTRAINT FK_ARTICLE_VIDEO_VIDEO FOREIGN KEY (VideoID) REFERENCES [dbo].[VIDEO](VideoID);


select * from [dbo].[ARTICLE]

-------------------------Procedure để lấy danh sách bài viết theo nhóm tin tức---------------------------
CREATE PROCEDURE GetArticlesByCategory
    @Category NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ArticleID,Category,Title, Url, Date, Writer, [Content]
    FROM dbo.ARTICLE
    WHERE Category = @Category
    ORDER BY Date DESC;
END;

--DROP PROCEDURE GetArticlesByCategory;
EXEC GetArticlesByCategory @Category =N'Thế giới'
EXEC GetArticlesByCategory @Category =N'Văn hóa'


-------------------------Procedure để lấy bài viết mới nhất--------------------------
CREATE PROCEDURE GetLatestArticles
    @Top INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP (@Top) ArticleID, Title, Url, Date, Writer, [Content]
    FROM dbo.ARTICLE
    ORDER BY Date DESC;
END;

EXEC GetLatestArticles @Top = 5;

-------------------------Function để đếm số lượng bài viết trong một nhóm tin tức--------------------------
CREATE FUNCTION CountArticlesByCategory(@Category NVARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @Count INT;

    SELECT @Count = COUNT(*)
    FROM dbo.ARTICLE
    WHERE Category = @Category;

    RETURN @Count;
END;

SELECT dbo.CountArticlesByCategory(N'Thời sự') AS TotalArticles;

-------------------------Procedure để tìm kiếm bài viết theo tiêu đề--------------------------
CREATE PROCEDURE SearchArticlesByTitle
    @Keyword NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ArticleID, Title, Url, Date, Writer, [Content]
    FROM dbo.ARTICLE
    WHERE Title LIKE '%' + @Keyword + '%'
    ORDER BY Date DESC;
END;

EXEC SearchArticlesByTitle @Keyword = N'Trường';

-------------------------Procedure để lấy hình ảnh của bài viết 5 bài đăng mới nhất-----------------------------
CREATE PROCEDURE GetLatestArticlesImages
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LatestArticles TABLE (ArticleID NVARCHAR(255));

    INSERT INTO @LatestArticles (ArticleID)
    SELECT TOP 5 ArticleID
    FROM dbo.ARTICLE
    ORDER BY Date DESC;

    SELECT a.ArticleID, a.Title, i.ImageUrl, i.Description, i.Source
    FROM dbo.IMAGE i
    INNER JOIN dbo.ARTICLE_IMAGE ai ON i.ImageID = ai.ImageID
    INNER JOIN dbo.ARTICLE a ON ai.ArticleID = a.ArticleID
    WHERE a.ArticleID IN (SELECT ArticleID FROM @LatestArticles)
    ORDER BY a.Date DESC;
END;

EXEC GetLatestArticlesImages;




CREATE PROCEDURE GetArticleVideosByTitle
    @Keyword NVARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy danh sách bài viết có tiêu đề chứa từ khóa
    DECLARE @ArticleIDs TABLE (ArticleID NVARCHAR(255));

    INSERT INTO @ArticleIDs (ArticleID)
    SELECT ArticleID
    FROM dbo.ARTICLE
    WHERE Title LIKE '%' + @Keyword + '%';

    -- Lấy danh sách video liên quan đến các bài viết tìm được
    SELECT a.ArticleID, a.Title, v.VideoUrl, v.Description
    FROM dbo.VIDEO v
    INNER JOIN dbo.ARTICLE_VIDEO av ON v.VideoID = av.VideoID
    INNER JOIN dbo.ARTICLE a ON av.ArticleID = a.ArticleID
    WHERE a.ArticleID IN (SELECT ArticleID FROM @ArticleIDs)
    ORDER BY a.Date DESC;
END;

EXEC GetArticleVideosByTitle @Keyword = N'Hai phi hành gia mắc kẹt trên';