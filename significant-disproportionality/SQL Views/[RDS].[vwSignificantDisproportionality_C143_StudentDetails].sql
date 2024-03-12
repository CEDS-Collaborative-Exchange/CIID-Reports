USE [generate-bi]
GO

/****** Object:  View [RDS].[vwSignificantDisproportionality_C143_StudentDetails]    Script Date: 2/27/2024 12:14:17 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER VIEW [RDS].[vwSignificantDisproportionality_C143_StudentDetails] AS

--================================================================================================
-- Discipline
--================================================================================================
WITH
DisciplineFilteredFactData 
AS
	(
SELECT				Fact.K12StudentId
					,Fact.PrimaryDisabilityTypeID
					,Fact.SchoolYearId
					,rdp.K12StudentStudentIdentifierState
					,Schools.SchoolIdentifierSea
					,Fact.LeaId
					,Fact.RaceId
					,LEAs.LeaIdentifierSea
					,LEAs.LeaIdentifierNces
					,Fact.IdeaStatusId					
					,Fact.GradeLevelId
					,Fact.AgeId					
					,rdds.DisciplineMethodOfChildrenWithDisabilitiesEdFactsCode
					,rdds.DisciplinaryActionTakenEdFactsCode
					,rdds.IdeaInterimRemovalEdFactsCode
					,rdds.IdeaInterimRemovalReasonEdFactsCode
					,rdds.EducationalServicesAfterRemovalEdFactsCode
					,Fact.DurationOfDisciplinaryAction
					,Fact.DisciplineCount					
					,1 AS DisciplineStudentCount
					,SeaId
		FROM   		RDS.FactK12StudentDisciplines	Fact
		JOIN		RDS.DimSchoolYears				SchoolYears		ON Fact.SchoolYearId		= SchoolYears.DimSchoolYearId	
		INNER JOIN  rds.DimPeople					rdp				on fact.K12StudentId		= rdp.DimPersonId
		INNER JOIN  RDS.DimLeas                     LEAs            ON Fact.LeaId               = LEAs.DimLeaId
		INNER JOIN  RDS.DimK12Schools               Schools         ON Fact.K12SchoolId         = Schools.DimK12SchoolId
		INNER JOIN  RDS.DimIdeaStatuses				rdis 			ON fact.IdeaStatusId		= rdis.DimIdeaStatusId
		LEFT JOIN   RDS.DimAges                     Ages            ON Fact.AgeId               = Ages.DimAgeId      
		LEFT JOIN   RDS.DimRaces                    Races           ON Fact.RaceId              = Races.DimRaceId
		INNER JOIN  RDS.DimIdeaDisabilityTypes		IDEADisability  ON Fact.PrimaryDisabilityTypeId = IDEADisability.DimIdeaDisabilityTypeId
		INNER JOIN rds.DimDisciplineStatuses		rdds 			ON fact.DisciplineStatusId = rdds.DimDisciplineStatusId
		WHERE 1 = 1
		AND Fact.SeaId <> -1
		AND Fact.LeaId <> -1
		AND Fact.K12SchoolId <> -1 
		AND rdis.IdeaEducationalEnvironmentForSchoolAgeCode <> 'PPPS'
			and rdis.IdeaIndicatorEdFactsCode = 'IDEA'
			and (rdds.DisciplineMethodOfChildrenWithDisabilitiesCode <> 'MISSING'
				or rdds.DisciplinaryActionTakenCode IN ('03086', '03087')
				or rdds.IdeaInterimRemovalReasonCode <> 'MISSING'
				or rdds.IdeaInterimRemovalCode <> 'MISSING')
		AND Ages.AgeValue >= 3 and Ages.AgeValue <= 21
		),
AggregateC143
AS
	(
		SELECT		 fact.K12StudentId								
					,fact.SchoolYearId
					,fact.LeaId
					,fact.RaceId
					,fact.GradeLevelId
					,fact.PrimaryDisabilityTypeID
					,fact.LeaIdentifierSea
					,fact.LeaIdentifierNces
					,sum(isnull(fact.DisciplineCount, 0)) AS DisciplineCount
					
		FROM		DisciplineFilteredFactData AS fact
		GROUP BY	fact.SchoolYearId, fact.LeaId, fact.LeaIdentifierSea,LeaIdentifierNces, fact.K12StudentId, fact.RaceId,fact.GradeLevelId ,fact.PrimaryDisabilityTypeID
		HAVING 		SUM(fact.DurationOfDisciplinaryAction) >= 0.5 
	)

	Select * from AggregateC143

GO


