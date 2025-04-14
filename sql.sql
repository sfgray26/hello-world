WITH DistinctCommentData AS (
    SELECT DISTINCT
        projectIdentifier,
        loginName,
        corporateEmail,
        UserID,
        accountID,
        CombinedLoanDetailComments,
        startTimeUTC -- Assuming this is needed in the CTE
    FROM CombinedComments
)
SELECT
    LTRIM(RTRIM(' Project ' + CAST(ISNULL(dcd.projectIdentifier, '') AS VARCHAR(50)))) AS "@Perspective",
    CAST(ISNULL(dcd.projectIdentifier, '') AS VARCHAR(50)) AS "RoomID",
    CAST(ISNULL(dcd.startTimeUTC, '0') AS VARCHAR(20)) AS "startTimeUTC",
    CAST(ISNULL(dcd.startTimeUTC, '0') AS VARCHAR(20)) AS "endTimeUTC",
    (
        SELECT
            CAST(COALESCE(NULLIF(LTRIM(dcd_inner.loginName), ''), 'Unknown User') AS VARCHAR(50)) AS "loginName",
            CAST(ISNULL(dcd_inner.projectIdentifier, '') AS VARCHAR(50)) AS "RoomID",
            CAST(ISNULL(dcd_inner.startTimeUTC, '0') AS VARCHAR(20)) AS "startTimeUTC",
            CAST(ISNULL(dcd_inner.startTimeUTC, '0') AS VARCHAR(20)) AS "endTimeUTC"
        FROM DistinctCommentData dcd_inner -- Added FROM clause
        WHERE dcd_inner.projectIdentifier = dcd.projectIdentifier -- Example WHERE clause
        FOR XML PATH('Participant'), TYPE -- Added FOR XML PATH
    ) AS ParticipantEntered,
    (
        SELECT
            CAST(COALESCE(NULLIF(LTRIM(dcd_inner.loginName), ''), 'Unknown User') AS VARCHAR(50)) AS "loginName",
            CAST(ISNULL(dcd_inner.startTimeUTC, '0') AS VARCHAR(20)) AS "DateTimeUTC",
            'true' AS "InternalFlag",
            CAST(ISNULL(dcd_inner.projectIdentifier, '') AS VARCHAR(50)) AS "ConversationID",
            CAST(COALESCE(NULLIF(dcd_inner.corporateEmail, ''), 'No Email') AS VARCHAR(100)) AS "CorporateEmailID"
        FROM DistinctCommentData dcd_inner -- Added FROM clause
        WHERE dcd_inner.projectIdentifier = dcd.projectIdentifier -- Example WHERE clause
        FOR XML PATH('InternalParticipant'), TYPE -- Added FOR XML PATH
    ) AS InternalParticipantEntered,
    (
        CASE
            WHEN dcd.CombinedLoanDetailComments IS NOT NULL AND LTRIM(RTRIM(dcd.CombinedLoanDetailComments)) != ''
            THEN (
                SELECT
                    CAST(COALESCE(NULLIF(LTRIM(RTRIM(dcd_inner.loginName)), ''), 'UnknownUser') AS varchar(50)) AS "loginName",
                    CAST(ISNULL(dcd_inner.startTimeUTC, '0') AS VARCHAR(20)) AS "DateTimeUTC",
                    CAST('Comments: ' + dcd_inner.CombinedLoanDetailComments AS varchar(MAX)) AS "Content"
                FROM DistinctCommentData dcd_inner -- Added FROM clause
                WHERE dcd_inner.projectIdentifier = dcd.projectIdentifier -- Example WHERE clause
                FOR XML PATH('Comment'), TYPE -- Added FOR XML PATH
            )
            ELSE (
                SELECT
                    CAST(COALESCE(NULLIF(LTRIM(RTRIM(uc.loginName)), ''), 'Unknown User') AS varchar(50)) AS "loginName",
                    CAST(ISNULL(uc.startTimeUTC, '0') AS varchar(20)) AS "DateTimeUTC",
                    CAST(uc.CommentText AS VARCHAR(MAX)) AS "Content"
                FROM UnpivotedComments uc
                WHERE uc.projectIdentifier = dcd.projectIdentifier
                FOR XML PATH('AlternativeComment'), TYPE -- Added FOR XML PATH
            )
        END
    ) AS Message
FROM DistinctCommentData dcd;
