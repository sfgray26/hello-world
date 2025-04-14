WITH DistinctCommentData AS (
    SELECT DISTINCT
        projectIdentifier,
        startTimeUTC,
        loginName,
        corporateEmail,
        UserID,
        accountID,
        CombinedLoanDetailComments
    FROM CombinedComments
)
SELECT
    LTRIM(RTRIM(' Project ' + CAST(dcd.projectIdentifier AS varchar(50)))) AS "@Perspective",
    CAST(dcd.projectIdentifier AS varchar(50)) AS "RoomID",
    CAST(ISNULL(dcd.startTimeUTC, 0) AS VARCHAR(20)) AS "startTimeUTC",
    CAST(ISNULL(dcd.startTimeUTC, 0) AS VARCHAR(20)) AS "endTimeUTC",
    (
        SELECT
            CAST(COALESCE(NULLIF(LTRIM(RTRIM(dcd.loginName)), ''), 'Unknown User') AS VARCHAR(50)) AS "loginName",
            CAST(ISNULL(dcd.startTimeUTC, 0) AS varchar(20)) AS "DateTimeUTC",
            'true' AS "InternalFlag",
            CAST(dcd.projectIdentifier AS VARCHAR(50)) AS "ConversationID",
            CAST(COALESCE(NULLIF(dcd.corporateEmail, ''), 'No Email') AS VARCHAR(100)) AS "CorporateEmailID"
        FOR XML PATH('ParticipantEntered'), TYPE
    ) AS ParticipantEntered,
    (
        CASE
            WHEN dcd.CombinedLoanDetailComments IS NOT NULL AND LTRIM(RTRIM(dcd.CombinedLoanDetailComments)) != ''
            THEN (
                SELECT
                    CAST(COALESCE(NULLIF(LTRIM(RTRIM(dcd.loginName)), ''), 'UnknownUser') AS varchar(50)) AS "loginName",
                    CAST(ISNULL(dcd.startTimeUTC, 0) AS VARCHAR(20)) AS "DateTimeUTC",
                    CAST('Comments: ' + dcd.CombinedLoanDetailComments AS varchar(MAX)) AS "Content"
                FOR XML PATH('Message'), TYPE
            )
            ELSE (
                SELECT
                    CAST(COALESCE(NULLIF(LTRIM(RTRIM(uc.loginName)), ''), 'Unknown User') AS varchar(50)) AS "loginName",
                    CAST(ISNULL(uc.startTimeUTC, 0) AS varchar(20)) AS "DateTimeUTC",
                    CAST(uc.CommentText AS VARCHAR(MAX)) AS "Content"
                FROM UnpivotedComments uc
                WHERE uc.projectIdentifier = dcd.projectIdentifier
                FOR XML PATH('Message'), TYPE
            )
        END
    ) AS Message
FROM DistinctCommentData dcd;
