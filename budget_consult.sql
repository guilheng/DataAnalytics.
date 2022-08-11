
--Revenue and budget consultation project.
--The total amount budgeted for revenue code 1.1.1.8.02.3.2 in the current year.
select
codigo_receita,
exercicio_orcamento,
sum(valor_orcamento) as total
from
  orcamento
  where codigo_receita = '1.1.1.8.02.3.2'
group by codigo_receita,exercicio_orcamento


--The percentage of increase (or decrease) of the total amount budgeted for the year 2021 in relation to 2020.
with calc as (
  select
exercicio_orcamento,
case 
 when exercicio_orcamento = '2020' then valor_orcamento
 else 0
 end calc20,
case
 when exercicio_orcamento = '2021' then valor_orcamento
 else 0
 end calc21
  from
 orcamento

),
soma as (
select 
sum(calc20) as total20,
sum(calc21) as total21
from
calc)
select 
((total21-total20)/total20*100) as 'Percentual'
from
soma


--Total amounts budgeted by revenue code, converting revenue code to int
with tb_2020 as (
select
codigo_receita,
exercicio_orcamento,
sum(valor_orcamento) as total
  from
    orcamento
  where
    exercicio_orcamento = '2020'
    group by codigo_receita, exercicio_orcamento
),
tb_2021 as (
  select
    codigo_receita,
exercicio_orcamento,
sum(valor_orcamento) as total
  from
    orcamento
  where
    exercicio_orcamento = '2021'
    group by codigo_receita, exercicio_orcamento
)
select
*
from
tb_2020
union
select
*
from
tb_2021


--The last date on which a value was recorded for the revenue code 1.1.1.8.02.3.2.
select 
codigo_receita,
first(data_receita) over (partition by codigo_receita order by data_receita desc) as last_date
from
receitas
where
codigo_receita = '1.1.1.8.02.3.2'



--What is the average amount of revenue for each code
select
  codigo_receita,
  avg(valor) as media
from
  receitas
group by codigo_receita



--The Total Amount of revenue for each year/year.
select 
year(data_receita) as ano,
sum(valor) as soma
from 
receitas


--Codes that had revenue in 2021 but had no revenue record in the previous 3 years.
select
  codigo_receita,
  year(data_receita) as ano
from
  receitas
where
  where data_receita between '2019-01-01' and '2021-01-01' is null



--Codes in which there was revenue in 2021 but that did not have a forecast for them in the budget
with filtro (
select
  r.codigo_receita,
  r.valor,
  o.valor_orcamento,
  o.exercicio_orcamento,
  case
   when o.valor = is not null and o.valor_orcamento is null then sem_orcamento
   when o.valor = is not null and o.valor_orcamento is not null then com_orcamento
  end orcamento_21
from
  receita as r
left join orcamento as o on r.codigo_receita = o.codigo_receita
where exercicio_orcamento = 2021
)
select
*
from 
filtro
where orcamento_21 = 'sem_orcamento'

