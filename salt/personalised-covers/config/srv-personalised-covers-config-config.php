<?php

return [
	{% if pillar.elife.env in ['ci', 'dev']  %}
	'debug' => true,
	'aws_credentials' => [
		'key' => 'test',
		'secret' => 'test'
	],
	'aws_endpoint' => 'http://127.0.0.1:4572/',
	{% else %}
	'debug' => false,
	{% endif %}
	'aws_region' => "{{ pillar.personalised_covers.aws.region }}",
	'aws_bucket' => "{{ pillar.personalised_covers.aws.bucket }}",
	'elife_api' => "{{ pillar.personalised_covers.api }}",
	'journal_url' => "{{ pillar.personalised_covers.journal_url }}",
	'font_path' => '/srv/personalised-covers/data/fonts/output',
	'cover_images' => [
		'load_paths' => [
			'a4' => '/srv/personalised-covers-data/formats/a4',
			'letter' => '/srv/personalised-covers-data/formats/letter'
		],
	],
	'gtm_id' => "{{ pillar.personalised_covers.gtm_id }}",
];

