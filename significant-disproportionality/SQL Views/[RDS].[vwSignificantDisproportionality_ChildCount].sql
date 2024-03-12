GO

/****** Object:  View [RDS].[vwSignificantDisproportionality_ChildCount]    Script Date: 2/27/2024 12:16:52 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [RDS].[vwSignificantDisproportionality_ChildCount] AS

--================================================================================================
-- Child Count
--================================================================================================

WITH ChildCountData 
AS
	(
		SELECT		 Fact.FactK12StudentCountId
					,Fact.PrimaryDisabilityTypeID
					,Fact.K12StudentId
					,Fact.SchoolYearId
					,Fact.LeaId
					,Fact.RaceId	
					,LEAs.LeaIdentifierSea
					,LEAs.LeaIdentifierNces
					,Fact.IdeaStatusId
					,Fact.GradeLevelId
					,Fact.AgeId
					,1 AS ChildCountStudentCount
 		FROM		RDS.FactK12StudentCounts			Fact
		JOIN		RDS.DimSchoolYears					SchoolYears			ON Fact.SchoolYearId			= SchoolYears.DimSchoolYearId	
		INNER JOIN	RDS.DimIdeaStatuses					IDEAStatus			ON Fact.IdeaStatusId			= IDEAStatus.DimIdeaStatusId
		LEFT JOIN	RDS.DimAges							Ages				ON Fact.AgeId					= Ages.DimAgeId      
		INNER JOIN	RDS.DimLeas							LEAs				ON Fact.LeaId					= LEAs.DimLeaId
		INNER JOIN	RDS.DimIdeaDisabilityTypes			IDEAType			ON Fact.PrimaryDisabilityTypeId = IDEAType.DimIdeaDisabilityTypeId

		WHERE 1 = 1
		AND Fact.FactTypeId = 3
		AND Fact.SeaId <> -1
		AND Fact.LeaId <> -1
		AND Fact.K12SchoolId <> -1
		AND IDEAType.IdeaDisabilityTypeCode <> 'MISSING'
		AND Ages.AgeValue >= 3 and Ages.AgeValue <= 21 

	)


	SELECT	*
	FROM	ChildCountData			AS childcount
						
GO


