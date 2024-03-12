GO

/****** Object:  View [RDS].[vwSignificantDisproportionality_Placement]    Script Date: 2/27/2024 12:21:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




ALTER VIEW [RDS].[vwSignificantDisproportionality_Placement] AS

--================================================================================================
-- Placement Child Count
--================================================================================================

SELECT 
	fsc.SchoolYearId, 
	dl.LeaIdentifierSea, 
	fsc.RaceId,
	fsc.GradeLevelId,
	fsc.PrimaryDisabilityTypeID,
	fsc.K12StudentId,
	dis.IdeaEducationalEnvironmentForSchoolAgeCode, 
	dis.IdeaEducationalEnvironmentForSchoolAgeDescription 
FROM rds.FactK12StudentCounts fsc
INNER JOIN RDS.DimIdeaStatuses					dis					ON fsc.IdeaStatusId = dis.DimIdeaStatusId
INNER JOIN	RDS.DimIdeaDisabilityTypes			IDEAType			ON fsc.PrimaryDisabilityTypeId = IDEAType.DimIdeaDisabilityTypeId
LEFT JOIN	RDS.DimAges							Ages				ON fsc.AgeId					= Ages.DimAgeId      
INNER JOIN RDS.DimLeas							dl					ON fsc.LeaId = dl.DimLeaId
WHERE 1 = 1
AND IDEAType.IdeaDisabilityTypeCode <> 'MISSING'
AND Ages.AgeValue >= 3 and Ages.AgeValue <= 21 

GO


