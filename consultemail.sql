
--Project to analyze the effectiveness of e-mails sent by the city hall to companies in the city.
--How many companies were notified by City Hall?
select distinct assunto from emails_enviados
where [enviado em] >= '2022-01-26' 

select count(distinct cnpj) as 'Empresas Notificadas'
from emails_enviados
where [enviado em] >= '2022-01-26' 
and assunto in (
    'Recadastramento mobiliário',
    'Cadastre sua empresa na prefeitura',
    'RECADASTRAMENTO OBRIGATÓRIO',
    'Cadastro Mobiliári',
    'RECADASTRAMENTO PROCESSO DIGITAL DE ALVARÁ',
    'RECADASTRAMENTO PROCESSO DIGITAL ALVARÁ',
    'Regularização de cadastro',
    'Errata - Cadastro Mobiliário',
	'RE: RE: Cadastro Mobiliário',
	'RE: RE: Errata - Cadastro Mobiliário',
	'RE: RE: Regularização de cadastro'
  )

--What was the opening percentage of the emails?
with treatment as (
select
case
  when [enviado em] >= '2022-01-26' then 1
  else 0
  end email_env,
case
  when [data abertura] >= '2022-01-26' then 1
  else 0
  end email_abert
from
emails_enviados
where
  assunto in (
    'Recadastramento mobiliário',
    'Cadastre sua empresa na prefeitura',
    'RECADASTRAMENTO OBRIGATÓRIO',
    'Cadastro Mobiliári',
    'RECADASTRAMENTO PROCESSO DIGITAL DE ALVARÁ',
    'RECADASTRAMENTO PROCESSO DIGITAL ALVARÁ',
    'Regularização de cadastro',
    'Errata - Cadastro Mobiliário',
	'RE: RE: Cadastro Mobiliário',
	'RE: RE: Errata - Cadastro Mobiliário',
	'RE: RE: Regularização de cadastro'
  ))

select
sum(email_env) as email_enviado,
sum(email_abert) as email_aberto,
round((sum(email_abert) * 1.0) / sum(email_env)*100, 2) as perc_aberto
from
treatment


--What percentage of companies registered with the City Hall until 03/01/2022?
select
count(*) as total_emp,
sum(case when dta_inclusao between '2022-01-26' and '2022-03-01' then 1 else 0 end) as qnt_emp,
round((sum(case when dta_inclusao between '2022-01-26' and '2022-03-01' then 1 else 0 end)* 1.0)/ count(*)*100, 2) as perc
FROM empresas_ativas_municipio


--On average, how many days does it take for a company to read the email sent?
select
round(avg(datediff(day, [enviado em], [data abertura])* 1.0), 2) as media_dia
from emails_enviados
where [data abertura] is not null and
  assunto in (
   'Recadastramento mobiliário',
    'Cadastre sua empresa na prefeitura',
    'RECADASTRAMENTO OBRIGATÓRIO',
    'Cadastro Mobiliári',
    'RECADASTRAMENTO PROCESSO DIGITAL DE ALVARÁ',
    'RECADASTRAMENTO PROCESSO DIGITAL ALVARÁ',
    'Regularização de cadastro',
    'Errata - Cadastro Mobiliário',
	'RE: RE: Cadastro Mobiliário',
	'RE: RE: Errata - Cadastro Mobiliário',
	'RE: RE: Regularização de cadastro'
  )


 -- Is there a pattern in companies that didn't read emails?
 --MAIN ECONOMIC ACTIVITY
 with nao_aberto as (
select des_atividade_principal
FROM empresas_ativas_receita as em
inner join emails_enviados as re on em.cnpj = re.cnpj
where [enviado em] >= '2022-01-26' and [data abertura] is null
group by des_atividade_principal ),
aberto as (
SELECT des_atividade_principal
FROM empresas_ativas_receita as em
inner join emails_enviados as re on em.cnpj = re.cnpj
where [enviado em] >= '2022-01-26' and [data abertura] is not null
group by des_atividade_principal
)
select * from nao_aberto as na
left join aberto as a on na.des_atividade_principal = a.des_atividade_principal
where a.des_atividade_principal is null
 

 --LEGAL NATURE
 with nao_aberto as(
select
des_natureza_juridica
from empresas_ativas_receita as em
inner join emails_enviados as re on em.cnpj = re.cnpj
where [enviado em] >= '2022-01-26' and [data abertura] is null
group by des_natureza_juridica ),
aberto as (
select
des_natureza_juridica
FROM empresas_ativas_receita as em
inner join emails_enviados as re on em.cnpj = re.cnpj
where [enviado em] >= '2022-01-26' and [data abertura] is not null
group by des_natureza_juridica
)
select * from nao_aberto as na
left join aberto as a on na.des_natureza_juridica = a.des_natureza_juridica
where a.des_natureza_juridica is null